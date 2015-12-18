#include <stdio.h>
#include <libserialport.h>
#include <jni.h>
#include <string.h>

JNIEXPORT jstring JNICALL Java_processing_app_Platform_resolveDeviceAttachedToNative
  (JNIEnv * env, jobject jobj, jstring serial)
{
	int i;
    struct sp_port **ports;

    char vid_pid_iserial[256] = " ";
	const char *port = (*env)->GetStringUTFChars(env, serial, NULL);
	jstring result;

    sp_list_ports(&ports);

    for (i = 0; ports[i]; i++) {
    	if (strncmp(port, sp_get_port_name(ports[i]), strlen(port)) == 0) {
	        int vid, pid;
			//printf("%s %d\n", ports[i], sp_get_port_usb_vid_pid(ports[i], &vid, &pid));
	        if (sp_get_port_usb_vid_pid(ports[i], &vid, &pid) == SP_OK) {
	        	snprintf(vid_pid_iserial, sizeof(vid_pid_iserial), "0x%04X_0x%04X_%s", vid, pid, sp_get_port_usb_serial(ports[i]));
	            break;
	        }
	    } else {
	    	continue;
	    }
    }

    sp_free_port_list(ports);
    (*env)->ReleaseStringUTFChars(env, serial, port);

    return (*env)->NewStringUTF(env, vid_pid_iserial);
}
