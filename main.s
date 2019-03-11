.syntax unified

.word 0x20000100
.word _start

.global _start
.type _start, %function
_start:
	mov r0, #100
	mov r1, #200
	mov r2, #300

	push {r0, r1, r2}
	pop {r3, r4, r5}

	push {r2, r0, r1}
	pop {r6, r7, r8}

	push {r2}
	push {r0}
	push {r1}
	pop {r9, r10, r11}

	//
	//branch w/o link
	//
	b	label01

label01:
	nop

	//
	//branch w/ link
	//
	bl	sleep

sleep:
	nop
	b	.
