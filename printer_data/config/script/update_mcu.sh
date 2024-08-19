#!/bin/bash

#chmod +x /home/biqu/printer_data/config/script/update_mcu.sh

#mkdir ~/firmware

#sudo service klipper stop

cd ~/katapult
git pull

make clean
#make menuconfig KCONFIG_CONFIG=/home/biqu/printer_data/config/script/config.manta_m5p.Katapult
make -j4 KCONFIG_CONFIG=/home/biqu/printer_data/config/script/config.manta_m5p.Katapult
mv ~/katapult/out/deployer.bin ~/firmware/manta_m5p_katapult.bin

make clean
#make menuconfig KCONFIG_CONFIG=/home/biqu/printer_data/config/script/config.ebb36.Katapult
make -j4 KCONFIG_CONFIG=/home/biqu/printer_data/config/script/config.ebb36.Katapult
mv ~/katapult/out/deployer.bin ~/firmware/ebb36_katapult.bin

cd ~/klipper
make clean
#make menuconfig KCONFIG_CONFIG=/home/biqu/printer_data/config/script/config.manta_m5p.CAN
make -j4 KCONFIG_CONFIG=/home/biqu/printer_data/config/script/config.manta_m5p.CAN
mv ~/klipper/out/klipper.bin ~/firmware/manta_m5p_klipper.bin

make clean
#make menuconfig KCONFIG_CONFIG=/home/biqu/printer_data/config/script/config.ebb36.CAN
make -j4 KCONFIG_CONFIG=/home/biqu/printer_data/config/script/config.ebb36.CAN
mv ~/klipper/out/klipper.bin ~/firmware/ebb36_klipper.bin

cd ~/katapult/scripts
## Update MCU EBB36
#echo "Start update MCU EBB36"
#echo ""
python3 flash_can.py -i can0 -u 59d755ed9e3b -f ~/firmware/ebb36_katapult.bin
sleep 2
python3 flash_can.py -i can0 -u 59d755ed9e3b -f ~/firmware/ebb36_klipper.bin
sleep 2
#read -p "MCU EBB36 firmware flashed, please check above for any errors. Press [Enter] to continue, or [Ctrl+C] to abort"
#echo "Finish update MCU EBB36"

# Update MCU Manta M5P
echo "Start update MCU Manta M5P"
echo ""
python3 flash_can.py -i can0 -u c7b31ed2d4a5 -f ~/firmware/manta_m5p_katapult.bin
sleep 2
python3 flash_can.py -d /dev/serial/by-id/usb-katapult_stm32g0b1xx_08002B000C504B5735313920-if00 -f ~/firmware/manta_m5p_katapult.bin
sleep 2
python3 flash_can.py -d /dev/serial/by-id/usb-katapult_stm32g0b1xx_08002B000C504B5735313920-if00 -f ~/firmware/manta_m5p_klipper.bin
#read -p "MCU Manta M5P firmware flashed, please check above for any errors. Press [Enter] to continue, or [Ctrl+C] to abort"
echo "Finish update MCU Manta M5P"

echo ""

#sudo service klipper start
