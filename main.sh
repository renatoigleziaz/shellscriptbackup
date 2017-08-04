#!/bin/bash

#
#  Descritivo: Shell Script para Backup
#  Roda      : Linux 
#  por       : Renato Igleziaz
#  Em        : 1/8/2017
#
<<<<<<< HEAD
#  Requerimentos : TAR, PV, DU, SPLIT, FIND 
=======
#  Requerimentos : TAG, PV, DU, SPLIT, FIND 
>>>>>>> 0431f16c488853acc7c8e9362ddb85c26439e0c2
#

# parametros suportados 
# ./main.sh     | Suporte a Menu
# ./main.sh 2   | Executa o backup da opcao 2
PARAM=$1

# Textos
VERSION="r7"
MYAPP="Backup Shell Script Pro ($VERSION)"
AUTOR="Renato Igleziaz @ xasten@gmail.com"
SAY="Digite o pacote de backup desejado:"

# menu com as opções de cópias, pode ter quantas
# forem necessárias
OP1="Backup do Windows para EXT"
OP2="Backup do Mac para EXT"
OP3="Backup do Mac para o PENDRIVE PENBKP"
OP4="Backup do Parallels para EXT"
OUT="Sair"

# tradução do restante do programa
TT1="Iniciando backup de"
TT2="Ja existe backup, tentando remover copias antigas..."
TT3="Removidos com sucesso."
TT4="Arquivos anteriores nao puderam ser removidos, por favor, verifique as permissoes de acesso."
TT5="Empacotando os arquivos de"
TT6="realizado"
TT7="nao realizado"
TT8="Ate outra hora, bye bye"
TT9="Argumento invalido, por favor, tente novamente."

# cores
COLORRESET='\e[0m'
SUB='\e[4m'
RED='\e[1;31m'
BLA='\e[1;37m'
YEL='\e[1;33m'
GRE='\e[1;32m'
BKG='\e[44m'

# expressions
VAL='^[0-9]+$'

exec_a_backup() {
   # processo principal do backup

   # parametros:
   # BKPORI -> pasta de origem
   # BKPDES -> pasta de destino
   # BKPSAV -> nome do arquivo
   # BKPCHK -> partes no nome para que seja removidos backups anteriores
   # BYTES  -> tamanho dos arquivos divididos   

   # parametros
   BKPORI=$1
   BKPDES=$2
   BKPSAV=$3
   BKPCHK=$4
   BYTES=$5

   # inicia   
   echo -e "${BLA}$TT1 $BKPORI...${COLORRESET}"

   #verifica se ja existe algum backup anterior
   if find $BKPDES -name $BKPCHK -print -quit | grep -q '^'
   then 
      echo -e "${YEL}$TT2${COLORRESET}"
      #tentando remover totalmente
      if rm $BKPDES/$BKPCHK
      then
         echo -e "${GRE}$TT3${COLORRESET}"
      else 
         echo -e "${RED}$TT4${COLORRESET}"
         exit 1
      fi
   fi

   #roda a legenda da pasta a ser zipada, tamanho e destino
   echo -e "${BLA}$TT5 $(du -bs -h $BKPORI) -> $BKPDES...${BKG}${BLA}"

   #roda o TAR, PV, SPLIT
   tar cf - $BKPORI -P | pv -s $(du -sb $BKPORI | awk '{print $1}') | split --bytes=$BYTES - $BKPDES/$BKPSAV

   #verifica se o tar gerou arquivos
   if find $BKPDES -name $BKPCHK -print -quit | grep -q '^'
   then
      echo -e "${COLORRESET}${GRE}Backup $BKPORI $TT6 !${COLORRESET}"
   else 
      echo -e "${COLORRESET}${RED}Error: $BKPORI $TT7 !!!${COLORRESET}"
   fi   
}

#
# Funções que executam a exec_a_backup com configurações para cada unidade de backup desejada
#

run_a_backup_windows() {
   #roda o backup do HD do Windows
   exec_a_backup /media/psf/WINDOWS/teste /media/psf/EXT/bkp-sh windows-teste.tar.gz windows-teste*.* 4024MB
   exec_a_backup /media/psf/WINDOWS/Projetos /media/psf/EXT/bkp-sh windows-dev.tar.gz windows-dev*.* 4024MB
   exec_a_backup /media/psf/WINDOWS/Outlook /media/psf/EXT/bkp-sh windows-outlook.tar.gz windows-outlook*.* 4024MB
   exec_a_backup /media/psf/WINDOWS/mkcomdev /media/psf/EXT/bkp-sh windows-mkcomdev.tar.gz windows-mkcomdev*.* 4024MB
   exec_a_backup /media/psf/WINDOWS/MAME /media/psf/EXT/bkp-sh windows-mame.tar.gz windows-mame*.* 4024MB
   exec_a_backup /media/psf/WINDOWS/Livros /media/psf/EXT/bkp-sh windows-livros.tar.gz windows-livros*.* 4024MB
   exec_a_backup /media/psf/WINDOWS/Emulator /media/psf/EXT/bkp-sh windows-emulator.tar.gz windows-emulator*.* 4024MB
   exec_a_backup /media/psf/WINDOWS/Users/Renato/Downloads /media/psf/EXT/bkp-sh windows-downloads.tar.gz windows-downloads*.* 4024MB
   exec_a_backup /media/psf/WINDOWS/Dolphin-win-x64-v3.0-913 /media/psf/EXT/bkp-sh windows-dolphin.tar.gz windows-dolphin*.* 4024MB
   exec_a_backup /media/psf/WINDOWS/Documentos /media/psf/EXT/bkp-sh windows-documentos.tar.gz windows-documentos*.* 4024MB
   exec_a_backup /media/psf/WINDOWS/cps3 /media/psf/EXT/bkp-sh windows-cps3.tar.gz windows-cps3*.* 4024MB
   exec_a_backup /media/psf/WINDOWS/Util /media/psf/EXT/bkp-sh windows-util.tar.gz windows-util*.* 4024MB
}

run_a_backup_mac() {
   #roda o backup do HD do MAC
   exec_a_backup /media/psf/SSD/projetos /media/psf/EXT/bkp-sh mac-projetos.tar.gz mac-projetos*.* 4024MB
   exec_a_backup /media/psf/SSD/Documentos /media/psf/EXT/bkp-sh mac-documentos.tar.gz mac-documentos*.* 1024MB
   exec_a_backup /media/psf/SSD/bash /media/psf/EXT/bkp-sh mac-bash.tar.gz mac-bash*.* 1024MB
}

run_a_backup_mac_pendrive() {
   #roda o backup do HD do MAC para o pen drive
   exec_a_backup /media/psf/SSD/projetos /media/psf/PENBKP/bkp-sh mac-projetos.tar.gz mac-projetos*.* 4024MB
   exec_a_backup /media/psf/SSD/Documentos /media/psf/PENBKP/bkp-sh mac-documentos.tar.gz mac-documentos*.* 1024MB
   exec_a_backup /media/psf/SSD/bash /media/psf/PENBKP/bkp-sh mac-bash.tar.gz mac-bash*.* 1024MB
}

run_a_backup_parallels() {
   #roda o backup das Maquinas Virtuais   
   exec_a_backup /media/psf/SSD/Parallels /media/psf/EXT/bkp-sh parallels.tar.gz parallels*.* 4024MB
}

start() {
   #
   # Menu de opções para iniciar o backup
   #

   # somente se algo for informado
   if [ -n $get ]; then

      # checa se eh um numero
      if ! [[ $get =~ $VAL ]]; then
         echo -e "${RED}$TT9${COLORRESET}"
         exit 1
      fi   
    
      # verifica se o resultado eh de 1-4
      # caso contrario sai fora  
      if [ $get -eq "0" ]; then
         echo -e "${RED}$TT8 !"
         exit 1
      fi

      # verifica qual opcao deve tomar
      if [ $get -eq "1" ]; then
         #windows
         run_a_backup_windows
         exit 1
      elif [ $get -eq "2" ]; then
         #mac
         run_a_backup_mac
         exit 1
      elif [ $get -eq "3" ]; then
         #mac-pendrive
         run_a_backup_mac_pendrive
         exit 1      
      elif [ $get -eq "4" ]; then
         #vms
         run_a_backup_parallels
         exit 1
      else
         # bye bye
         echo -e "${GRE}$TT8${COLORRESET}"
      fi        
   fi   
}

# main
clear
echo -e "${BLA}$MYAPP${COLORRESET}" 
echo -e "${SUB}$AUTOR${COLORRESET}" 

# verifica se foi passado algum parametro para  
# inicio automatico sem menu
if [ -n "$PARAM" ]; then
   get=$PARAM 
   echo -e "${YEL}Auto Mode: $PARAM${COLORRESET}" 
else
   echo -e "${GRE}$SAY${COLORRESET}" 
   echo -e "${BLA}1 ${YEL}$OP1${COLORRESET}" 
   echo -e "${BLA}2 ${YEL}$OP2${COLORRESET}" 
   echo -e "${BLA}3 ${YEL}$OP3${COLORRESET}" 
   echo -e "${BLA}4 ${YEL}$OP4${COLORRESET}" 
   echo -e "${BLA}5 ${YEL}$OUT${COLORRESET}" 
   read get
fi

# menu de escolhas
start 

exit 1
