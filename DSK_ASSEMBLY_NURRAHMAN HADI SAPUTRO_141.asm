.model small
.stack 100h
.data
    judul db 13,10,'=== CEK KELAS MAHASISWA ===$'
    inputMsg db 13,10,'Masukkan NIM: $'
    kelasCMsg db 13,10,'MAHASISWA KELAS C$'
    bukanCMsg db 13,10,'BUKAN KELAS C$'
    ulangMsg db 13,10,'Cek NIM lagi? (Y/T): $'

    nimMin db '2500018001'
    nimMax db '2500018249'

    buffer db 12
           db ?
           db 12 dup(?)

.code
main proc
    mov ax, @data
    mov ds, ax

ulang_program:
    ; Judul
    lea dx, judul
    mov ah, 09h
    int 21h

    ; Input NIM
    lea dx, inputMsg
    mov ah, 09h
    int 21h

    lea dx, buffer
    mov ah, 0Ah
    int 21h

    ; 1. Cek panjang NIM = 10
    mov al, buffer+1
    cmp al, 10
    jne bukan_kelas_c

    ; 2. Cek karakter angka
    lea si, buffer+2
    mov cx, 10
cek_digit:
    mov al, [si]
    cmp al, '0'
    jb bukan_kelas_c
    cmp al, '9'
    ja bukan_kelas_c
    inc si
    loop cek_digit

    ; 3. Bandingkan NIM minimum
    lea si, buffer+2
    lea di, nimMin
    mov cx, 10
cek_min:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jb bukan_kelas_c
    ja cek_max
    inc si
    inc di
    loop cek_min

cek_max:
    ; 4. Bandingkan NIM maksimum
    lea si, buffer+2
    lea di, nimMax
    mov cx, 10
cek_max_loop:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    ja bukan_kelas_c
    jb kelas_c
    inc si
    inc di
    loop cek_max_loop

kelas_c:
    lea dx, kelasCMsg
    mov ah, 09h
    int 21h
    jmp tanya_ulang

bukan_kelas_c:
    lea dx, bukanCMsg
    mov ah, 09h
    int 21h

tanya_ulang:
    lea dx, ulangMsg
    mov ah, 09h
    int 21h

    ; Input Y / T
    mov ah, 01h
    int 21h
    cmp al, 'Y'
    je ulang_program
    cmp al, 'y'
    je ulang_program

    ; selain Y/y ? keluar
    mov ah, 4Ch
    int 21h

main endp
end main
