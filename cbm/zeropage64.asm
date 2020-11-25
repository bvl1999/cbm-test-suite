; often used zeropage locations

cpugpioctl    = $00                  ; cpu gpio port direction register
cpugpio       = $01                  ; cpu gpio port
;               $02                  ; not in use
fp2intptr     = $03                  ; ptr to routine for converting float to signed int
int2fpptr     = $05                  ; ptr to routine for converting int to float
searchch1     = $07                  ; tmp storage for x register for jmpfar/jsrfar
searchch2     = $08                  ; tmp storage for y register for jmpfar/jsrfar
bverifyflag   = $09                  ; BASIC load/verify flag

basicstart    = $2b                  ; start of basic
variablestart = $2d                  ; start of variables
arraystart    = $2f                  ; start of arrays
stringstart   = $31                  ; start of strings
strbot        = $33                  ; start of free memory
strpooltmpptr = $35                  ; temporary pointer into string pool
memorytop     = $37                  ; top of memory
basicline     = $39                  ; basic line number
prevline      = $3b                  ; previous line number
basicchrptr   = $3d                  ; basic char input pointer
dataline      = $3f                  ; line number of current data statement
dataptr       = $41                  ; pointer to next data item
inputptr      = $43                  ; input text pointer
variablename  = $45                  ; current variable name
variableval   = $47                  ; current variable value


iecstatus     = $90                  ; iec device status register
stkey         = $91                  ; value of stop key row
verifyflag    = $93                  ; load/verify
tmpxstore     = $97                  ; temporary storage for X register
ldtnd         = $98                  ; number of open files
inputdev      = $99                  ; current input device
outputdev     = $9a                  ; current output device
msgflg        = $9d                  ; kernal message flag
kworkptr1     = $ac                  ; location for current byte during tape and disk load/save
kworkptr2     = $ae                  ; end address for tape and disk load/save operations
namelen       = $b7                  ; filename length
lfnum         = $b8                  ; logical file number
secaddr       = $b9                  ; secondary address
dv            = $ba                  ; current iec device number
filename      = $bb                  ; current file name pointer
bootdev       = $bf                  ; boot device for phoenix (petscii)
kaddrptr1     = $c1                  ; holds start address during save or current t/s numbers during disk boot
kaddrptr2     = $c3                  ; holds load address (used when secondary address is 0) and used as working pointer during reset
ndx           = $c6                  ; index into keyboard buffer
curkey        = $cb
scrwidth      = $ee                  ; current screen width
uval1         = $fa                  ; free (user temp val 1)
uptr1         = $fb                  ; user pointer 1
uptr2         = $fd                  ; user pointer 2
