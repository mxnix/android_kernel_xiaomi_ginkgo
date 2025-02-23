/*
 * Contains CPU specific branch predictor invalidation sequences
 *
 * Copyright (C) 2018 ARM Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <linux/linkage.h>
#include <linux/arm-smccc.h>

.macro ventry target
	.rept 31
	nop
	.endr
	b	\target
.endm

.macro vectors target
	ventry \target + 0x000
	ventry \target + 0x080
	ventry \target + 0x100
	ventry \target + 0x180

	ventry \target + 0x200
	ventry \target + 0x280
	ventry \target + 0x300
	ventry \target + 0x380

	ventry \target + 0x400
	ventry \target + 0x480
	ventry \target + 0x500
	ventry \target + 0x580

	ventry \target + 0x600
	ventry \target + 0x680
	ventry \target + 0x700
	ventry \target + 0x780
.endm

	.align	11
ENTRY(__bp_harden_hyp_vecs_start)
	.rept 4
	vectors __kvm_hyp_vector
	.endr
ENTRY(__bp_harden_hyp_vecs_end)


ENTRY(__smccc_workaround_1_smc_start)
	sub	sp, sp, #(8 * 4)
	stp	x2, x3, [sp, #(8 * 0)]
	stp	x0, x1, [sp, #(8 * 2)]
	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_1
	smc	#0
	ldp	x2, x3, [sp, #(8 * 0)]
	ldp	x0, x1, [sp, #(8 * 2)]
	add	sp, sp, #(8 * 4)
ENTRY(__smccc_workaround_1_smc_end)

ENTRY(__smccc_workaround_3_smc_start)
	sub     sp, sp, #(8 * 4)
	stp     x2, x3, [sp, #(8 * 0)]
	stp     x0, x1, [sp, #(8 * 2)]
	mov     w0, #ARM_SMCCC_ARCH_WORKAROUND_3
	smc     #0
	ldp     x2, x3, [sp, #(8 * 0)]
	ldp     x0, x1, [sp, #(8 * 2)]
	add     sp, sp, #(8 * 4)
ENTRY(__smccc_workaround_3_smc_end)

ENTRY(__spectre_bhb_loop_k8_start)
	sub     sp, sp, #(8 * 2)
	stp     x0, x1, [sp, #(8 * 0)]
	mov     x0, #8
2:	b       . + 4
	subs    x0, x0, #1
	b.ne    2b
	dsb     nsh
	isb
	ldp     x0, x1, [sp, #(8 * 0)]
	add     sp, sp, #(8 * 2)
ENTRY(__spectre_bhb_loop_k8_end)

ENTRY(__spectre_bhb_loop_k24_start)
	sub     sp, sp, #(8 * 2)
	stp     x0, x1, [sp, #(8 * 0)]
	mov     x0, #24
2:	b       . + 4
	subs    x0, x0, #1
	b.ne    2b
	dsb     nsh
	isb
	ldp     x0, x1, [sp, #(8 * 0)]
	add     sp, sp, #(8 * 2)
ENTRY(__spectre_bhb_loop_k24_end)

ENTRY(__spectre_bhb_loop_k32_start)
	sub     sp, sp, #(8 * 2)
	stp     x0, x1, [sp, #(8 * 0)]
	mov     x0, #32
2:	b       . + 4
	subs    x0, x0, #1
	b.ne    2b
	dsb     nsh
	isb
	ldp     x0, x1, [sp, #(8 * 0)]
	add     sp, sp, #(8 * 2)
ENTRY(__spectre_bhb_loop_k32_end)
