#!/bin/sh

status="0"
OUTPUT_FREQ=434.0
LAST_ITEM="0 Tune"
do_freq_setup()
{

if FREQ=$(whiptail --inputbox "Çalışma frekansını (MHz) yazın, Varsayılan 434 MHz" 8 78 $OUTPUT_FREQ --title "Rpitx Gönderme Frekansı" 3>&1 1>&2 2>&3); then
    OUTPUT_FREQ=$FREQ
fi

}

do_stop_transmit()
{
	sudo killall tune 2>/dev/null
	sudo killall pichirp 2>/dev/null
	sudo killall spectrumpaint 2>/dev/null
	sudo killall pifmrds 2>/dev/null
	sudo killall sendiq 2>/dev/null
	sudo killall pocsag 2>/dev/null
	sudo killall piopera 2>/dev/null
	sudo killall rpitx 2>/dev/null
	sudo killall freedv 2>/dev/null
	sudo killall pisstv 2>/dev/null
	sudo killall csdr 2>/dev/null
	sudo killall pirtty 2>/dev/null

	case "$menuchoice" in
			
			0\ *) sudo killall testvfo.sh >/dev/null 2>/dev/null ;;
			1\ *) sudo killall testvfo.sh >/dev/null 2>/dev/null ;;
			2\ *) sudo killall testspectrum.sh >/dev/null 2>/dev/null ;; 
			3\ *) sudo killall snap2spectrum.sh >/dev/null 2>/dev/null ;;
			4\ *) sudo killall  testfmrds.sh >/dev/null 2>/dev/null ;;
			5\ *) sudo killall testnfm.sh >/dev/null 2>/dev/null ;;
			6\ *) sudo killall testssb.sh >/dev/null 2>/dev/null ;;
			7\ *) sudo killall testam.sh >/dev/null 2>/dev/null ;;
			8\ *) sudo killall testfreedv.sh >/dev/null 2>/dev/null ;;
			9\ *) sudo killall testsstv.sh >/dev/null 2>/dev/null ;;
			10\ *) sudo killall testpocsag.sh >/dev/null 2>/dev/null ;;
			11\ *) sudo killall testopera.sh >/dev/null 2>/dev/null ;;
			12\ *) sudo killall testrtty.sh >/dev/null 2>/dev/null ;;
			
	esac		
}

do_status()
{
	 LAST_ITEM="$menuchoice"
	whiptail --title "Gönderim frekansı ""$OUTPUT_FREQ"" MHz (""$LAST_ITEM"")"  --msgbox "Gönderiliyor" 8 78
	do_stop_transmit
}


do_freq_setup

 while [ "$status" -eq 0 ]
    do

 menuchoice=$(whiptail --default-item "$LAST_ITEM" --title "Rpitx TX ""$OUTPUT_FREQ"" MHz" --menu "Frekans Aralığı : 50kHz-1GHz. Seçim yapınız" 20 82 12 \
 	"F Frekans Değiştirme" "Çalışma frekansınızı (şu anda $OUTPUT_FREQ MHz) değiştirin" \
	"0 Taşıyıcı Gönderimi" "Taşıyıcı" \
    "1 Tarama" "Frekans Tarama" \
	"2 Spektrum Resim Çizme" "Spektrumda Resim" \
	"3 Kameradan Çizdir" "Kamera Görüntüsünü Spektruma Çizdir" \
	"4 FM RDS" "FM Radyo yayını (RDS'li)" \
	"5 NFM" "Dar Band FM" \
	"6 SSB" "Tek Tan Band Modülasyonu (USB)" \
	"7 AM" "Genlik Modülasyonu (Düşük Kalite)" \
	"8 FreeDV" "Dijital Ses Haberleşmesi 800XA" \
	"9 SSTV" "Pattern picture" \
	"10 Pocsag" "Çağrı Cihazına Mesaj" \
    "11 Opera" "Mors benzeri, opera decoder gerektirir" \
    "12 RTTY" "Radioteletype" \
 	3>&2 2>&1 1>&3)
		RET=$?
		if [ $RET -eq 1 ]; then
    		exit 0
		elif [ $RET -eq 0 ]; then
			case "$menuchoice" in
			F\ *) do_freq_setup ;;
			0\ *) "./testvfo.sh" "$OUTPUT_FREQ""e6" >/dev/null 2>/dev/null &
			do_status;;
			1\ *) "./testchirp.sh" "$OUTPUT_FREQ""e6" >/dev/null 2>/dev/null &
			do_status;;
			2\ *) "./testspectrum.sh" "$OUTPUT_FREQ""e6" >/dev/null 2>/dev/null &
			do_status;;
			3\ *) "./snap2spectrum.sh" "$OUTPUT_FREQ""e6" >/dev/null 2>/dev/null &
			do_status;;
			4\ *) "./testfmrds.sh" "$OUTPUT_FREQ" >/dev/null 2>/dev/null &
			do_status;;
			5\ *) "./testnfm.sh" "$OUTPUT_FREQ""e3" >/dev/null 2>/dev/null &
			do_status;;
			6\ *) "./testssb.sh" "$OUTPUT_FREQ""e6" >/dev/null 2>/dev/null &
			do_status;;
			7\ *) "./testam.sh" "$OUTPUT_FREQ""e3" >/dev/null 2>/dev/null &
			do_status;;
			8\ *) "./testfreedv.sh" "$OUTPUT_FREQ""e6" >/dev/null 2>/dev/null &
			do_status;;
			9\ *) "./testsstv.sh" "$OUTPUT_FREQ""e6">/dev/null 2>/dev/null &
			do_status;;
			10\ *) "./testpocsag.sh" "$OUTPUT_FREQ""e6">/dev/null 2>/dev/null &
			do_status;;
			11\ *) "./testopera.sh" "$OUTPUT_FREQ""e6">/dev/null 2>/dev/null &
			do_status;;
			12\ *) "./testrtty.sh" "$OUTPUT_FREQ""e6">/dev/null 2>/dev/null &
			do_status;;
			*)	 status=1
			whiptail --title "Bye bye" --msgbox "Thx for using rpitx" 8 78
			;;
			esac
		else
			exit 1
		fi
    done
	exit 0

