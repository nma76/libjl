//
// Module that handles environment
//

.section .rodata 
.align 4 

env_username_label:
.asciz "USERNAME"

env_home_label:
.asciz "HOME"

env_shell_label:
.asciz "SHELL"

.include "macros.inc"

.section .text

.global env_get_username
.global env_get_home
.global env_get_shell

env_get_username:
    PROLOGUE

    adrp x0, env_username_label
    add x0, x0, :lo12:env_username_label
    bl envp_get

    EPILOGUE

env_get_home:
    PROLOGUE

    adrp x0, env_home_label
    add x0, x0, :lo12:env_home_label
    bl envp_get

    EPILOGUE

env_get_shell:
    PROLOGUE

    adrp x0, env_shell_label
    add x0, x0, :lo12:env_shell_label
    bl envp_get

    EPILOGUE    