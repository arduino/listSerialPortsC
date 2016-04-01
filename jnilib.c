#include <stdio.h>
#include <libserialport.h>
#include <jni.h>
#include <string.h>

JNIEXPORT jstring JNICALL Java_processing_app_Platform_resolveDeviceAttachedToNative
  (JNIEnv * env, jobject jobj, jstring serial)
{
	struct sp_port *port;

	char vid_pid_iserial[256] = " ";
	const char *portname = (*env)->GetStringUTFChars(env, serial, NULL);
	jstring result;

	sp_get_port_by_name(portname, &port);

	int vid, pid;
	if (sp_get_port_usb_vid_pid(port, &vid, &pid) == SP_OK) {
		snprintf(vid_pid_iserial, sizeof(vid_pid_iserial), "0x%04X_0x%04X_%s", vid, pid, sp_get_port_usb_serial(port));
	}

	sp_free_port(port);
	(*env)->ReleaseStringUTFChars(env, serial, portname);

	return (*env)->NewStringUTF(env, vid_pid_iserial);
}

#ifndef _WIN32

JNIEXPORT jobjectArray JNICALL Java_processing_app_Platform_listSerialsNative
  (JNIEnv * env, jobject jobj)
{
	struct sp_port **ports;
	jobjectArray ret;
	int i;

	char portname_vid_pid[256] = " ";

	sp_list_ports(&ports);

	// like ports.size()
	for (i = 0; ports[i]; i++) {};

	ret = (jobjectArray)(*env)->NewObjectArray(env, i, (*env)->FindClass(env, "java/lang/String"), (*env)->NewStringUTF(env, ""));

	int vid, pid;
	for (i = 0; ports[i]; i++) {
		int vid, pid;
		if (sp_get_port_usb_vid_pid(ports[i], &vid, &pid) == SP_OK) {
			snprintf(portname_vid_pid, sizeof(portname_vid_pid), "%s_%04X_%04X", sp_get_port_name(ports[i]), vid, pid);
		} else {
			snprintf(portname_vid_pid, sizeof(portname_vid_pid), "%s_%04X_%04X", sp_get_port_name(ports[i]), 0, 0);
		}
		(*env)->SetObjectArrayElement(env, ret, i, (*env)->NewStringUTF(env, portname_vid_pid));
	}

	sp_free_port_list(ports);

	return ret;
}

#else

// use listcomports code
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdarg.h>
#include <string.h>
#include <unistd.h>


#include <windows.h>
#include <setupapi.h>

#include <disphelper.h>

JNIEXPORT jobjectArray JNICALL Java_processing_app_Platform_listSerialsNative
  (JNIEnv * env, jobject jobj)
{
	jobjectArray ret;
	char portname_vid_pid[256] = " ";
	DISPATCH_OBJ(wmiSvc);
	DISPATCH_OBJ(colDevices);

	dhInitialize(TRUE);
	dhToggleExceptions(FALSE);

	dhGetObject(L"winmgmts:{impersonationLevel=impersonate}!\\\\.\\root\\cimv2",
	//dhGetObject(L"winmgmts:\\\\.\\root\\cimv2",
	            NULL, &wmiSvc);
	dhGetValue(L"%o", &colDevices, wmiSvc,
	           L".ExecQuery(%S)",
	           L"Select * from Win32_PnPEntity");

	int port_count = 0;
	int vid = 0;
	int pid = 0;
	int i = 0;

	struct sp_port **ports;
	sp_list_ports(&ports);

	// like ports.size()
	for (i = 0; ports[i]; i++) {};
	sp_free_port_list(ports);

	ret = (jobjectArray)(*env)->NewObjectArray(env, i, (*env)->FindClass(env, "java/lang/String"), (*env)->NewStringUTF(env, ""));

	FOR_EACH(objDevice, colDevices, NULL) {
	    char* name = NULL;
	    char* pnpid = NULL;
	    char* match;

	    dhGetValue(L"%s", &name,  objDevice, L".Name");
	    dhGetValue(L"%s", &pnpid, objDevice, L".PnPDeviceID");

	    if( name != NULL && ((match = strstr( name, "(COM" )) != NULL) ) { // look for "(COM23)"
	        char* comname = strtok( match, "()");
	        char id_s[5];
	        char * pch;
	        pch = strstr (pnpid,"VID_");
	        strncpy(id_s, pch + 4, 4);
	        vid = strtol(id_s, NULL, 16);
	        pch = strstr (pnpid,"PID_");
	        strncpy(id_s, pch + 4, 4);
	        pid = strtol(id_s, NULL, 16);
	        //sscanf(pnpid, "%*sVID_%4X", vid);
	        //sscanf(pnpid, "%*sPID_%4X", pid);
	        snprintf(portname_vid_pid, sizeof(portname_vid_pid), "%s_%04X_%04X", comname, vid, pid);
	        if (port_count < i) {
	            // only store element if safe (operations are not atomic)
	            (*env)->SetObjectArrayElement(env, ret, port_count, (*env)->NewStringUTF(env, portname_vid_pid));
	        }
	        port_count++;
	    }
	    dhFreeString(name);
	    dhFreeString(pnpid);

	} NEXT(objDevice);

	for (; port_count < i; port_count++) {
	    // fill the array with copies of the last good value (operations are not atomic)
	    (*env)->SetObjectArrayElement(env, ret, port_count, (*env)->NewStringUTF(env, portname_vid_pid));
	}

	SAFE_RELEASE(colDevices);
	SAFE_RELEASE(wmiSvc);

	dhUninitialize(TRUE);

	return ret;
}

#endif