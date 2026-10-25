#include <nds.h>
#include <stdio.h>

int main(void) {
    consoleDemoInit();

    printf("================================\n");
    printf("   IL MIO PRIMO HOMEBREW NDS!   \n");
    printf("================================\n");
    printf("\nCompilato automaticamente\n");
    printf("tramite GitHub Actions!\n");
    printf("\nPremere START per uscire.");

    while(1) {
        scanKeys();
        u16 keys = keysDown();
        if (keys & KEY_START) {
            break; 
        }
        swiWaitForVBlank();
    }

    return 0;
}
