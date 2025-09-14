main: #memory: 1-16 boardArr; 17-32 visited; 33-64 groupArr; 65 computer move; 66 computer move is_invalid; 67 is white score (1); 68 is black score (2); 69 is analyze_player; 500 is initial sp
    #r1 = visited array position; r2 = counter; r3 = 14
    addi $r1, $r0, 17   #r1 = 17; memory location of visited
    addi $r28, $r0, 33  #mem location of groupArr
    addi $r2, $r0, 0  #r2 = 0; r2 is counter
    addi $r3, $r0, 15  #r3 = 15; 
    addi $r29, $r0, 500  #init stack ptr to 500, use r29 as sp
    nop
    nop
    sw $r0, 66($r0) #init computer_mpve_is_invalid to false
    

    #check if is in analyze_player, if so skip to init loop
    lw $r24, 69($r0) #r24 = player_mode
    
    bne $r24, $r0, init_visited_and_group_loop #if player_mode != 0, then skip to init_visited_and_group_loop
    
               
    #check if computer move is repeated
    lw $r24, 65($r0) #computer move
    lw $r23, 1($r24) #color at computer move pos
    addi $r6, $r0, 1 #r6 = 1
    addi $r5, $r0, 2 #r5 = 2
    bne $r23, $r5, skip2 # if neq 2 or 1, then its empty and valid
    sw $r6, 66($r0)
    j end
    skip2:
    addi $r5, $r0, 1 #r5 = 1
    bne $r23, $r5, store_comp_move
    sw $r6, 66($r0)
    j end

    store_comp_move:
    #if computer move not repeated, add it into the boardArr
    addi $r23, $r0, 2 #r23 = 2
    lw $r24, 65($r0) #r24 = computer move
    sw $r23, 1($r24) #store 2 into the computer's move position in boardArr 


init_visited_and_group_loop:
    blt $r3, $r2, DFS_total  #if (r2 >= 16) then go to DFS_total
    sw $r0, 0($r1)  #visited[r1] = 0
    sw $r0, 0($r28) #groupArr[i] = 0
    addi $r1, $r1, 1  #r1 = r1 + 1; increment array position
    addi $r28, $r28, 1 #increment groupArr ptr
    addi $r2, $r2, 1  #r2 = r2 + 1; increment counter
    j init_visited_and_group_loop



# -------------------------------------------------------------------- DFS_total --------------------------------------------------------------------------
DFS_total: #r1 = x pos; r2 = y pos
    addi $r1, $r0, 0  #r1 = 0
    addi $r2, $r0, 0  #r2 = 0
    addi $r5, $r0, 1
    
    
    
   outer_loop:
       addi $r2, $r0, 0  #ypos = 0
       inner_loop:
           addi $r3, $r0, 3  #r3 = 3
           blt $r3, $r2, end_inner_loop  #if 3 < ypos (in other words, ypos >= 4), exit inner_loop 
           addi $r5, $r0, 4  #r5 = 4 
           mul $r6, $r1, $r5  #r6 = 4*xpos
           add $r7, $r6, $r2  #r7 = 4*xpos + ypos, r7 = visited array pos of (x,y)
           addi $r4, $r7, 17  #r4 = r4+r7, r4 = mem pos of visited[x][y]
           addi $r14, $r7, 1  #r14 = mem pos of boardArr[x][y]
           lw $r25, 0($r14)  #r25 = boardArr[x][y], ie color of current piece
           lw $r8, 0($r4)  #r8 = visited[x][y]
           bne $r8, $r0, end_DFS_call  #if r8 != 0 (ie r8 == 1), then skip DFS

           bne $r25, $r0, start_DFS_call # if the piece pos is not empty, go to DFS. If empty, skip DFS
           j end_DFS_call

           start_DFS_call:
           add $r11, $r0, $r1  #r11 = DFS xpos
           add $r12, $r0, $r2  #r12 = DFS ypos
           addi $r5, $r0, 1  #r5 = 1
           sub $r29, $r29, $r5  #decrement sp
           sw $r31, 0($r29)  #store ra
           jal DFS   #run DFS on the current board position
           lw $r31, 0($r29)  #load ra
           addi $r29, $r29, 1 #increment sp
           

           #check if should eliminate 
           addi $r9, $r0, 1  #r9 = 1
           sub $r29, $r29, $r9  #increase stack by 1
           sw $r31, 0($r29)  #store return address
           jal check_elimination
           lw $r31, 0($r29)
           addi $r29, $r29, 1
           end_DFS_call:

           
            addi $r2, $r2, 1  #ypos++

          
            
            j inner_loop  
            end_inner_loop:
       # j end #debug 
        addi $r1, $r1, 1  #xpos++
        addi $r3, $r0, 3  #r3 = 3
        blt $r3, $r1, end_outer_loop    #if 3 < xpos (in other words, xpos >= 4), exit outer_loop
        j outer_loop
        end_outer_loop:

#check this
    j end #debug


# ------------------------------------------------------------------------------------ DFS -------------------------------------------------------------------------------
DFS: #r11 = DFS xpos; r12 = ypos; r25 = color
    #mark as visited
    addi $r5, $r0, 4  #r5 = 4
    mul $r6, $r11, $r5  #r6 = 4*xpos
    add $r7, $r6, $r12  #r7 = 4*xpos + ypos, r7 = visited array pos of (x,y)
    addi $r4, $r7, 17  #r4 = r4+r7, r4 = mem pos of visited[x][y]
    addi $r19, $r7, 33  #r19 = mem pos of groupArr[x][y]
    addi $r8, $r0, 1  #r8 = 1
    sw $r8, 0($r19)  #group[x][y] = 1
    sw $r8, 0($r4)  #visited[x][y] = 1


    recurse_top:
    #recurse top:------  r14 is new xpos; r15 is new ypos
    addi $r13, $r0, 1  #r13 = 1
    sub $r14, $r11, $r13  #r14 = xpos - 1; xpos array pos of top 
    blt $r14, $r0, recurse_bottom   #skip recursion if xpos - 1 < 0

    addi $r5, $r0, 4  #r5 = 4
    mul $r6, $r14, $r5  #r6 = 4*xpos
    add $r7, $r6, $r12  #r7 = 4*xpos + ypos, r7 = visited array pos of (x,y)
    addi $r4, $r7, 17  #r4 = r4+r7, r4 = mem pos of visited[x][y]
    addi $r20, $r7, 1   #r20 = boardArr[x][y] (ie color)
    lw $r21, 0($r20)
    lw $r8, 0($r4)  #r8 = visited[x][y]
    addi $r9, $r0, 0 #r9 = 0
    bne $r8, $r9, recurse_bottom  #if r8 != 0 (ie r8 == 1), then skip DFS recursion
    bne $r21, $r25, recurse_bottom  #skip DFS recursion if not the same color

    addi $r9, $r0, 3  #r9 = 3
    sub $r29, $r29, $r9  #decrease sp by 3
    sw $r11, 0($r29)  #store xpos somewhere in memory
    sw $r12, 1($r29)  #store ypos somewhere in memory
    sw $r31, 2($r29)  #store return address in memory
    add $r11, $r0, $r14  #set recursed xpos to xpos - 1
    lw $r12, 1($r29)   #set recursed ypos to current ypos
    jal DFS
    lw $r11, 0($r29)
    lw $r12, 1($r29)
    lw $r31, 2($r29)
    addi $r29, $r29, 3  #return sp to original position


    recurse_bottom:
    #recurse bottom:------  r14 is new xpos; r15 is new ypos
    addi $r14, $r11, 1  #r14 = xpos + 1; xpos array pos of top 
    addi $r13, $r0, 3
    blt $r13, $r14, recurse_left   #skip recursion if 3 < xpos + 1 (ie xpos + 1 >= 4)

    addi $r5, $r0, 4  #r5 = 4
    mul $r6, $r14, $r5  #r6 = 4*xpos
    add $r7, $r6, $r12  #r7 = 4*xpos + ypos, r7 = visited array pos of (x,y)
    addi $r4, $r7, 17  #r4 = r4+r7, r4 = mem pos of visited[x][y]
    addi $r20, $r7, 1   #r20 = boardArr[x][y] (ie color)
    lw $r21, 0($r20)
    lw $r8, 0($r4)  #r8 = visited[x][y]
    addi $r9, $r0, 0 #r9 = 0
    bne $r8, $r9, recurse_left  #if r8 != 0 (ie r8 == 1), then skip DFS recursion
    bne $r21, $r25, recurse_left  #skip if not same color

    addi $r9, $r0, 3  #r9 = 3
    sub $r29, $r29, $r9  #decrease sp by 3
    sw $r11, 0($r29)  #store current xpos somewhere in memory
    sw $r12, 1($r29)  #store current ypos somewhere in memory
    sw $r31, 2($r29)
    add $r11, $r0, $r14  #set recursed xpos to xpos + 1
    lw $r12, 1($r29)   #set recursed ypos to current ypos
    jal DFS
    lw $r11, 0($r29)
    lw $r12, 1($r29)
    lw $r31, 2($r29)
    addi $r29, $r29, 3  #return sp to original position


    recurse_left:
    #recurse left-----
    addi $r13, $r0, 1
    sub $r15, $r12, $r13  #r15 = ypos - 1
    blt $r15, $r0, recurse_right  #skip recursion if ypos - 1 < 0

    addi $r5, $r0, 4  #r5 = 4
    mul $r6, $r11, $r5  #r6 = 4*xpos
    add $r7, $r6, $r15  #r7 = 4*xpos + ypos, r7 = visited array pos of (x,y)
    addi $r4, $r7, 17  #r4 = r4+r7, r4 = mem pos of visited[x][y]
    addi $r20, $r7, 1   #r20 = boardArr[x][y] (ie color)
    lw $r8, 0($r4)  #r8 = visited[x][y]
    lw $r21, 0($r20)
    addi $r9, $r0, 0 #r9 = 0
    bne $r8, $r9, recurse_right  #if r8 != 0 (ie r8 == 1), then skip DFS recursion
    bne $r21, $r25, recurse_right #skip if not same color

    addi $r9, $r0, 3  #r9 = 3
    sub $r29, $r29, $r9  #decrease sp by 3
    sw $r11, 0($r29)  #store current xpos somewhere in memory
    sw $r12, 1($r29)  #store current ypos somewhere in memory
    sw $r31, 2($r29)
    lw $r11, 0($r29)  #recursed xpos = current xpos
    add $r12, $r15, $r0  #recursed ypos = current ypos - 1
    jal DFS
    lw $r11, 0($r29)
    lw $r12, 1($r29)
    lw $r31, 2($r29)
    addi $r29, $r29, 3  #return sp to original position


    recurse_right:
    #recurse right-----
    addi $r15, $r12, 1  #r15 = ypos + 1
    addi $r13, $r0, 3  #r13 = 3
    blt $r13, $r15, finished_DFS  #skip recursion if 3 < ypos + 1 (ie ypos + 1 >= 4)

    addi $r5, $r0, 4  #r5 = 4
    mul $r6, $r11, $r5  #r6 = 4*xpos
    add $r7, $r6, $r15  #r7 = 4*xpos + ypos, r7 = visited array pos of (x,y)
    addi $r4, $r7, 17  #r4 = r4+r7, r4 = mem pos of visited[x][y]
    addi $r20, $r7, 1   #r20 = boardArr[x][y] (ie color)
    lw $r8, 0($r4)  #r8 = visited[x][y]
    lw $r21, 0($r20)
    addi $r9, $r0, 0 #r9 = 0
    bne $r8, $r9, finished_DFS  #if r8 != 0 (ie r8 == 1), then skip DFS recursion
    bne $r21, $r25, finished_DFS #skip if not same color

    addi $r9, $r0, 3  #r9 = 3
    sub $r29, $r29, $r9  #decrease sp by 3
    sw $r11, 0($r29)  #store current xpos somewhere in memory
    sw $r12, 1($r29)  #store current ypos somewhere in memory
    sw $r31, 2($r29)
    lw $r11, 0($r29)  #recursed xpos = current xpos
    add $r12, $r15, $r0  #recursed ypos = current ypos + 1
    jal DFS
    lw $r11, 0($r29)
    lw $r12, 1($r29)
    lw $r31, 2($r29)
    addi $r29, $r29, 3  #return sp to original position


    finished_DFS:


    jr $r31



# ------------------------------------------------------------------------------ check_elimination ------------------------------------------------------------------
check_elimination: #r11 = xpos; r12 = ypos
    addi $r28, $r0, 0  #r28 stores if computer move is in group
    addi $r11, $r0, 0  #r11 = 0
    addi $r12, $r0, 0  #r12 = 0

    outer_loop_eliminate:
        addi $r12, $r0, 0  #ypos = 0
        inner_loop_eliminate:

            #find groupArr[x][y]
            addi $r5, $r0, 4  #r5 = 4
            mul $r6, $r11, $r5  #r6 = 4*xpos
            add $r7, $r6, $r12  #r7 = 4*xpos + ypos, r7 = groupArr array pos of (x,y)
            addi $r4, $r7, 33  #r4 = r4+r7, r4 = mem pos of groupArr[x][y]
            lw $r8, 0($r4)  #r8 = groupArr[x][y]
            addi $r9, $r0, 1  #r9 = 1
            bne $r8, $r9, end_iteration  #skip if groupArr[x][y] < 1 (ie if groupArr[x][y] = 0); find N

            #check if computer move in groupArr
            lw $r26, 65($r0)  #r26 = computer move  --------------------
            bne $r7, $r26, check_top  #if current pos != computer move, don't set r28 to true -------------------------
            addi $r28, $r0, 1  #r28 = true; r28 denotes if computer move is in groupArr ----------------------------------


            check_top:
            #r14 = check xpos; r15 = check ypos
            #check top----------------------------------    
            addi $r13, $r0, 1  #r13 = 1
            sub $r14, $r11, $r13  #r14 = xpos - 1; xpos array pos of top 
            blt $r14, $r0, check_bottom   #skip recursion if xpos - 1 < 0

            addi $r5, $r0, 4  #r5 = 4
            mul $r6, $r14, $r5  #r6 = 4*xpos
            add $r7, $r6, $r12  #r7 = 4*xpos + ypos, r7 = boardArr pos of (x - 1,y)
            addi $r4, $r7, 1  #r4 = r4+r7, r4 = mem pos of boardArr[x - 1][y]
            lw $r8, 0($r4)  #r8 = boardArr[x - 1][y]
            bne $r8, $r0, check_bottom  #if boardArr[x-1][y] != 0, do not skip elimination
            j check_elimination_done
            


            check_bottom:
            #check bottom:------------------------------
            addi $r14, $r11, 1  #r14 = xpos + 1; xpos array pos of top 
            addi $r13, $r0, 3
            blt $r13, $r14, check_left   #skip recursion if 3 < xpos + 1 (ie xpos + 1 >= 4)

            addi $r5, $r0, 4  #r5 = 4
            mul $r6, $r14, $r5  #r6 = 4*xpos
            add $r7, $r6, $r12  #r7 = 4*xpos + ypos, r7 = boardArr pos of (x,y)
            addi $r4, $r7, 1  #r4 = r4+r7, r4 = mem pos of boardArr[x][y]
            lw $r8, 0($r4)  #r8 = boardArr[x][y]
            bne $r8, $r0, check_left  #if boardArr[x-1][y] != 0, do not skip elimination
            j check_elimination_done

            check_left:
            #recurse left-----
            addi $r13, $r0, 1
            sub $r15, $r12, $r13  #r15 = ypos - 1
            blt $r15, $r0, check_right  #skip recursion if ypos - 1 < 0

            addi $r5, $r0, 4  #r5 = 4
            mul $r6, $r11, $r5  #r6 = 4*xpos
            add $r7, $r6, $r15  #r7 = 4*xpos + ypos, r7 = boardArr array pos of (x,y)
            addi $r4, $r7, 1  #r4 = r4+r7, r4 = mem pos of boardArr[x][y]
            lw $r8, 0($r4)  #r8 = boardArr[x][y]
            bne $r8, $r0, check_right  #if boardArrArr[x-1][y] != 0, do not skip elimination
            j check_elimination_done


            check_right:
            #recurse right-----
            addi $r15, $r12, 1  #r15 = ypos + 1
            addi $r13, $r0, 3  #r13 = 3
            blt $r13, $r15, end_iteration  #skip recursion if 3 < ypos + 1 (ie ypos + 1 >= 4)

            addi $r5, $r0, 4  #r5 = 4
            mul $r6, $r11, $r5  #r6 = 4*xpos
            add $r7, $r6, $r15  #r7 = 4*xpos + ypos, r7 = boardArr array pos of (x,y)
            addi $r4, $r7, 1  #r4 = r4+r7, r4 = mem pos of boardArr[x][y]
            lw $r8, 0($r4)  #r8 = boardArr[x][y]
            bne $r8, $r0, end_iteration  #if boardArr[x-1][y] != 0, do not skip elimination
            j check_elimination_done



            end_iteration:
            addi $r3, $r0, 3  #r3 = 3
            addi $r12, $r12, 1  #ypos++
            blt $r3, $r12, end_check_elimination_inner_loop #if 3 < ypos (in other words, ypos >= 4), exit inner_loop  
            j inner_loop_eliminate
            end_check_elimination_inner_loop:


        addi $r11, $r11, 1  #xpos++
        addi $r3, $r0, 3  #r3 = 3
        blt $r3, $r11, end_check_elimination_outer_loop    #if 3 < xpos (in other words, xpos >= 4), exit outer_loop
        j outer_loop_eliminate
        end_check_elimination_outer_loop:


    #elimination
    lw $r27, 69($r0) #r27 = player_mode
    bne $r27, $r0, skip1 #if player_mode != 0, then skip to skip 1
    addi $r10, $r0, 1  #r10 = 1
    bne $r28, $r10, skip1  #if r28 != 1 (ie computer move not in groupArr), skip to skip1
    sw $r10, 66($r0)  #store invalid_move = true 
    lw $r27, 65($r0) #r27 = computer move 
    sw $r0, 1($r27) #restore computer move position to 0 
    
    
    j end 
    skip1:
    sub $r29, $r29, $r10  #decrement sp
    sw $r31, 0($r29)  #store ra
    jal eliminate
    lw $r31, 0($r29)  #load ra
    addi $r29, $r29, 1 #incrememt sp



    check_elimination_done:
    #reset groupArr
    addi $r10, $r0, 1  #r10 = 1
    sub $r29, $r29, $r10  #decrement sp
    sw $r31, 0($r29)  #store ra
    jal group_reset 
    lw $r31, 0($r29)  #load ra
    addi $r29, $r29, 1 #incrememt sp

    jr $r31




# ------------------------------------------------------------------------------- eliminate ------------------------------------------------------------------------------
eliminate:
    addi $r6, $r0, 0  #r6 = counter
    addi $r7, $r0, 15 #r7 = 15

    eliminate_loop:
        blt $r7, $r6, break_eliminate_loop #skip if 15 < counter (ie counter >= 16)

        addi $r8, $r6, 33  #r8 = mem pos of element in groupArr
        lw $r9, 0($r8)  #r9 = element value in groupArr

        addi $r10, $r6, 1  #r10 = mem pos of element in boardArr
        lw $r11, 0($r10)  #r11 = element value in boardArr

        addi $r12, $r0, 1  #r12 = 1
        bne $r9, $r12, continue_eliminate_loop   #skip if groupArr element is not 1
        sw $r0, 0($r8)  #reset element in groupArr to 0
        sw $r0, 0($r10)  #set element in boardArr to 0

        continue_eliminate_loop:
        addi $r6, $r6, 1  #increment counter
        j eliminate_loop

    break_eliminate_loop:
    
    jr $r31


# -------------------------------------------------------------------------------------- group_reset ------------------------------------------------------------
group_reset:

    addi $r4, $r0, 33  #r4 = mem pos of groupArr
    addi $r6, $r0, 0  #r6 = counter
    addi $r7, $r0, 15 #r7 = 15

    reset_loop:
        blt $r7, $r6, break_reset_loop #skip if 15 < counter (ie counter >= 16)

        addi $r8, $r6, 33  #r8 = mem pos of element in groupArr
        sw $r0, 0($r8)  #set element in groupArr to 0

        addi $r6, $r6, 1  #increment counter
        j reset_loop

    break_reset_loop:
    
    jr $r31







#sw $r0, 66($r0)




end:
    check_score:
        # update score
        addi $r1, $r0, 1 #r1 = 1; mem pos of boardArr
        addi $r2, $r0, 16 #r2 = 16
        addi $r3, $r0, 0 # r3 = white score (1)
        addi $r4, $r0, 0 #r4 = black score (2)
        addi $r21, $r0, 1 #r21 = 1
        addi $r22, $r0, 2 #r22 = 2

        score_loop:
            blt $r2, $r1, score_loop_done  #stop if 16 < r1 (if r1 >= 17)
            lw $r5, 0($r1) #r5 = piece color
            
            bne $r5, $r21, not_white #don't increment white score if not white
            addi $r3, $r3, 1 #increment white score
            j not_black

            not_white:
            bne $r5, $r22, not_black #don't increment black score if not black
            addi $r4, $r4, 1 #increment black score

            not_black:
            addi $r1, $r1, 1 #increment ptr
            j score_loop

        score_loop_done:
        sw $r3, 67($r0) #store scores in memory
        sw $r4, 68($r0)


    infinite_loop:
        nop
        j infinite_loop



test_end: #debug
    addi $r1, $r0, 1
    sw $r1, 75($r0) #debug
    infinite_loop_test_end:

        nop
        j infinite_loop_test_end