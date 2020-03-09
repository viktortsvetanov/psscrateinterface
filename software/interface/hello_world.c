#include <stdio.h>
#include <string.h>
#include "system.h"
#include <unistd.h>
#include "system.h"
#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include <io.h>
//include "altera_up_avalon_character_lcd.h"

#define ONCHIP_MEMORY2_0_BASE 0x10004000
#define PIO_0_BASE 0x00000000

int main ()
{
printf("Tggg"); //T is the identifier
while (1)
{
if (IORD_ALTERA_AVALON_PIO_EDGE_CAP(PIO_0_BASE) == 1)
{
IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_0_BASE, 0x1);
alt_busy_sleep(10000);
printf("Module="); //T is the identifier
printf("%d",IORD(ONCHIP_MEMORY2_0_BASE, 0)); // IORD_32DIRECT(ONCHIP_MEMORY2_0_BASE, 0));
alt_busy_sleep(10000);
printf("\r Port="); //T is the identifier
printf("%d",IORD(ONCHIP_MEMORY2_0_BASE, 1)); // IORD(ONCHIP_MEMORY2_0_BASE, 1));
alt_busy_sleep(10000);
printf("\r Data="); //T is the identifier
printf("%X",IORD(ONCHIP_MEMORY2_0_BASE, 2)); // IORD(ONCHIP_MEMORY2_0_BASE, 2));
printf("\n\r"); //T is the identifier
alt_busy_sleep(1000);
alt_busy_sleep(300000);
}
}
return 0;
}
