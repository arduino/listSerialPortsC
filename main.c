#include <stdio.h>
#include <libserialport.h>

int main(void)
{
    int i;
    struct sp_port **ports;

    sp_list_ports(&ports);

    for (i = 0; ports[i]; i++) {
        int vid, pid;
        if (sp_get_port_usb_vid_pid(ports[i], &vid, &pid) == SP_OK) {
            printf("%s | %04X:%04X | %s %s %s\n", sp_get_port_name(ports[i]), vid, pid, sp_get_port_usb_serial(ports[i]), sp_get_port_usb_product(ports[i]), sp_get_port_usb_manufacturer(ports[i]));
        }
    }

    sp_free_port_list(ports);
}

