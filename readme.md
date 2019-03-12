HW02
===
This is the hw02 sample. Please follow the steps below.

# Build the Sample Program

1. Fork this repo to your own github account.

2. Clone the repo that you just forked.

3. Under the hw02 dir, use:

	* `make` to build.

	* `make clean` to clean the ouput files.

4. Extract `gnu-mcu-eclipse-qemu.zip` into hw02 dir. Under the path of hw02, start emulation with `make qemu`.

	See [Lecture 02 ─ Emulation with QEMU] for more details.

5. The sample is designed to help you to distinguish the main difference between the `b` and the `bl` instructions.  

	See [ESEmbedded_HW02_Example] for knowing how to do the observation and how to use markdown for taking notes.

# Build Your Own Program

1. Edit main.s.

2. Make and run like the steps above.

# HW02 Requirements

1. Please modify main.s to observe the `push` and the `pop` instructions:  

	Does the order of the registers in the `push` and the `pop` instructions affect the excution results?  

	For example, will `push {r0, r1, r2}` and `push {r2, r0, r1}` act in the same way?  

	Which register will be pushed into the stack first?

2. You have to state how you designed the observation (code), and how you performed it.  

	Just like how [ESEmbedded_HW02_Example] did.

3. If there are any official data that define the rules, you can also use them as references.

4. Push your repo to your github. (Use .gitignore to exclude the output files like object files or executable files and the qemu bin folder)

[Lecture 02 ─ Emulation with QEMU]: http://www.nc.es.ncku.edu.tw/course/embedded/02/#Emulation-with-QEMU
[ESEmbedded_HW02_Example]: https://github.com/vwxyzjimmy/ESEmbedded_HW02_Example

--------------------

- [ ] **If you volunteer to give the presentation next week, check this.**

--------------------

ECE_HW02
===
## 1.實驗題目
1. 觀察 `push` `pop` 在暫存器裡的行為
2. `push {r0, r1, r2}` and `push {r2, r0, r1}` 是否有差異?

## 2. 實驗
1. 編輯 main.s 後，`$ make` 編譯:
```assembly
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
```


2. 將資料夾 gnu-mcu-eclipse-qemu 完整複製到 ESEmbedded_HW02 資料夾中

3. 在 ESEmbedded_HW02 底下 `$ make qemu`，再開啟另一個 Terminal 連線 `$ arm-none-eabi-gdb`，輸入 `$ target remote 127.0.0.1:1234` 連接，輸入兩次的 `ctrl + x` 和數字 `2`，開啟 Register 以及指令，並且輸入 `si` 單步執行觀察。

	* 進入 gdb 
	![](https://i.imgur.com/Rp9Sivz.png)

	* 我使用 `mov` 先把 `r0, #100`、`r1, #200`、`r2, #300`
	![](https://i.imgur.com/R6WY9Vf.png)
	![](https://i.imgur.com/oqJrLux.png)
	![](https://i.imgur.com/TGxHHI6.png)

	* 使用單步執行 `push {r0, r1, r2}` 發現，原本 `sp = 0x20000100` 會變成 `0x200000f4`
    ![](https://i.imgur.com/TGxHHI6.png)

    * `pop {r3, r4, r5}`，利用 `pop` 指令將 stack 裡的值 pop 到 r3,r4,r5
    ![](https://i.imgur.com/eV8MliO.png)

    * 再 `push {r2, r0, r1}` ，`pop {r6, r7, r8}` 觀察，發現 `push {r0, r1, r2}` 和 `push {r2, r0, r1}` pop 出來的結果是相同的
    ![](https://i.imgur.com/ZYI0GXA.png)
    ![](https://i.imgur.com/VQ3SuMk.png)
    
    * 實驗把 `push {r2, r0, r1}` 寫成 `push {r2}`、`push {r0}`、`push {r1}` 後，再 `pop {r9, r10, r11}`，發現與前兩個實驗結果不同
    ![](https://i.imgur.com/ONFFjsm.png)
    ![](https://i.imgur.com/YbPznVY.png)
    ![](https://i.imgur.com/lJ9YCjp.png)
    ![](https://i.imgur.com/6jRDWkW.png)
    
## 3. 結果與討論
1. `push {r2, r0, r1}` 和 `push {r0, r1, r2}` 結果為何相同，而與 `push {r2}`、`push {r0}`、`push {r1}` 結果不同?
    * 因為一次 push 多個 register 會將最高的 register 先放，最低的最後放
    * [Thumb2.pdf (push)](http://www.nc.es.ncku.edu.tw/course/embedded/pdf/Thumb2.pdf)
    ```
    Is a list of one or more registers, separated by commas and surrounded by { and }. It
    specifies the set of registers to be stored. The registers are stored in sequence, the
    lowest-numbered register to the lowest memory address, through to the highest-numbered
    register to the highest memory address
    ```

