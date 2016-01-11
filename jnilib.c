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
