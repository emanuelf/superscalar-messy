TERMINALBASE= 0xf00
TERMINALDATAREG= 0xf04
TRIGGERTERMINALWRITEINASCII= 0x00050000
READNEXTDATA=0x00020000

MASK_TIMER_INT=0x1
MASK_TERM_INT=0x2

BR Main
BR HWISR
BR SWISR

Main:
movi r1, DATA_ENABLE_INT
load r58, r1, 0
muli r58, r58, 2

Start:
movi r16, 10000
movi timerReg, 500

Loop1:
movi r0, 0

bnez r16, Loop1
HALT


Print:
movi r2, TERMINALDATAREG
store r1, r2, 0
movi r2, TERMINALBASE
movi r1, TRIGGERTERMINALWRITEINASCII
or r1, r1, r10
store r1, r2, 0
b lr
ShouldntBeReached:
movi r0,255
HALT


HWISR:
addi r8, interruptReg, 0
andi r9, r8, MASK_TIMER_INT
bnez r9, TIMERISR
br   TERMINALISR

TIMERISR:
#clear timer 
subi r16, r16, 1
addi r17, r17, 1
movi r8, 0
nori r9, r8, MASK_TIMER_INT
and  r58, r58, r9
movi timerReg, 500
RESUME


TERMINALISR:
movi r8, 0
nori r9, r8, MASK_TERM_INT
and  r58, r58, r9

movi r8, READNEXTDATA
movi r9, TERMINALBASE
load r10, r9, 8		
store r8, r9, 0
addi r7, r0,  Print
movi r1, 'r'	
bl r7
movi r1, 'e' 
bl r7
movi r1, 'a'
bl r7
movi r1, 'd'
bl r7
movi r1, ':'
bl r7
add r1, r0, r10
bl r7
movi r1, '\n'
bl r7
RESUME



SWISR:
movi r31, 1000
RESUME


OS_GLOBAL_DATA:
DATA_ENABLE_INT:
DATA 0x40000000

OS_STACK:
#0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#1
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#2
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#3
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#4
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#5
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#6
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#7
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#8
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#9
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#10
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#11
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#12
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#13
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#14
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#15
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#16
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#17
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#18
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#19
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
#20
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
DATA 0
