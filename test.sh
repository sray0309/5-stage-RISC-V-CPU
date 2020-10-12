#!/bin/bash

rm compare.out

if [[ $1 == "groundtruth" ]]        # run groundtruth and save writeback.out and program.out file in unpipe/
then 
    for file in test_progs/*.s; do  # run assembly code for groundtruth
        make clean
        filename=$(echo $file | cut -d'.' -f1 | cut -d'/' -f2)
        make assembly SOURCE=$file
        make groundtruth
        cp writeback.out unpipe/$filename"_writeback.out"
        cp program.out unpipe/$filename"_program.out"
    done
    for file in test_progs/*.c; do  # run C code for groundtruth
        make clean
        filename=$(echo $file | cut -d'.' -f1 | cut -d'/' -f2)
        make program SOURCE=$file
        make groundtruth
        cp writeback.out unpipe/$filename"_writeback.out"      # save "*_writeback.out" in unpipe/
        cp program.out unpipe/$filename"_program.out"          # save "*_program.out"   in unpipe/
    done
elif [[ $1 == "test" ]]            # run make and compare writeback.out and program.out with files in unpipe/
then
    for file in test_progs/*.s; do              # run verilog files
        make clean
        filename=$(echo $file | cut -d'.' -f1 | cut -d'/' -f2)
        make assembly SOURCE=$file
        make
        reg_result=$(diff writeback.out unpipe/$filename"_writeback.out")           # compare writeback.out file
        echo -e "\n$filename reg compare result: $reg_result" >> compare.out
        if [[ $reg_result == "" ]]
        then 
            echo -e "@@@reg test on $filename is Passed!">>compare.out
            echo -e "reg test on $filename is \033[32m Passed \033[0m"
        else
            echo -e "@@@reg test on $filename is Failed!">>compare.out
            echo -e "reg test on $filename is \033[31m Failed \033[0m"
        fi
        grep '@@@' unpipe/$filename"_program.out">unpipe_memresult.out
        grep '@@@' program.out>pipe_memresult.out
        mem_result=$(diff unpipe_memresult.out pipe_memresult.out)                  # compare program.out file
        echo -e "\n$filename mem compare result: $mem_result" >> compare.out
        if [[ $mem_result == "" ]]
        then 
            echo -e "@@@mem test on $filename is Passed!">>compare.out
            echo -e "mem test on $filename is \033[32m Passed \033[0m"
        else
            echo -e "@@@mem test on $filename is Failed!">>compare.out
            echo -e "mem test on $filename is \033[31m Failed \033[0m"
        fi
    done
    # for file in test_progs/*.c; do
    #     make clean
    #     filename=$(echo $file | cut -d'.' -f1 | cut -d'/' -f2)
    #     make program SOURCE=$file
    #     make
    #     reg_result=$(diff writeback.out unpipe/$filename"_writeback.out")
    #     echo -e "\n$filename reg compare result: $reg_result" >> compare.out
    #     if [[ $reg_result == "" ]]
    #     then 
    #         echo -e "@@@reg test on $filename is Passed!">>compare.out
    #         echo -e "reg test on $filename is \033[32m Passed \033[0m"
    #     else
    #         echo -e "@@@reg test on $filename is Failed!">>compare.out
    #         echo -e "reg test on $filename is \033[31m Failed \033[0m"
    #     fi
    #     grep '@@@' unpipe/$filename"_program.out">unpipe_memresult.out
    #     grep '@@@' program.out>pipe_memresult.out
    #     mem_result=$(diff unpipe_memresult.out pipe_memresult.out)
    #     echo -e "\n$filename mem compare result: $mem_result" >> compare.out
    #     if [[ $mem_result == "" ]]
    #     then 
    #         echo -e "@@@mem test on $filename is Passed!">>compare.out
    #         echo -e "mem test on $filename is \033[32m Passed \033[0m"
    #     else
    #         echo -e "@@@mem test on $filename is Failed!">>compare.out
    #         echo -e "mem test on $filename is \033[31m Failed \033[0m"
    #     fi
    # done
elif [[ $1 == "syntest" ]]            # run make and compare writeback.out and program.out with files in unpipe/
then
    for file in test_progs/*.s; do              # run verilog files
        make clean
        filename=$(echo $file | cut -d'.' -f1 | cut -d'/' -f2)
        make assembly SOURCE=$file
        make syn
        reg_result=$(diff writeback.out unpipe/$filename"_writeback.out")           # compare writeback.out file
        echo -e "\n$filename reg compare result: $reg_result" >> compare.out
        if [[ $reg_result == "" ]]
        then 
            echo -e "@@@reg test after syn on $filename is Passed!">>compare.out
            echo -e "reg test after syn on $filename is \033[32m Passed \033[0m"
        else
            echo -e "@@@reg test after syn on $filename is Failed!">>compare.out
            echo -e "reg test after syn on $filename is \033[31m Failed \033[0m"
        fi
        grep '@@@' unpipe/$filename"_program.out">unpipe_memresult.out
        grep '@@@' syn_program.out>pipe_memresult.out
        mem_result=$(diff unpipe_memresult.out pipe_memresult.out)                  # compare program.out file
        echo -e "\n$filename mem compare result: $mem_result" >> compare.out
        if [[ $mem_result == "" ]]
        then 
            echo -e "@@@mem test after syn on $filename is Passed!">>compare.out
            echo -e "mem test after syn on $filename is \033[32m Passed \033[0m"
        else
            echo -e "@@@mem test after syn on $filename is Failed!">>compare.out
            echo -e "mem test after syn on $filename is \033[31m Failed \033[0m"
        fi
    done
    # for file in test_progs/*.c; do
    #     make clean
    #     filename=$(echo $file | cut -d'.' -f1 | cut -d'/' -f2)
    #     make program SOURCE=$file
    #     make syn
    #     reg_result=$(diff writeback.out unpipe/$filename"_writeback.out")
    #     echo -e "\n$filename reg compare result: $reg_result" >> compare.out
    #     if [[ $reg_result == "" ]]
    #     then 
    #         echo -e "@@@reg test after syn on $filename is Passed!">>compare.out
    #         echo -e "reg test after syn on $filename is \033[32m Passed \033[0m"
    #     else
    #         echo -e "@@@reg test after syn on $filename is Failed!">>compare.out
    #         echo -e "reg test after syn on $filename is \033[31m Failed \033[0m"
    #     fi
    #     grep '@@@' unpipe/$filename"_program.out">unpipe_memresult.out
    #     grep '@@@' program.out>pipe_memresult.out
    #     mem_result=$(diff unpipe_memresult.out pipe_memresult.out)
    #     echo -e "\n$filename mem compare result: $mem_result" >> compare.out
    #     if [[ $mem_result == "" ]]
    #     then 
    #         echo -e "@@@mem test after syn on $filename is Passed!">>compare.out
    #         echo -e "mem test after syn on $filename is \033[32m Passed \033[0m"
    #     else
    #         echo -e "@@@mem test after syn on $filename is Failed!">>compare.out
    #         echo -e "mem test after syn on $filename is \033[31m Failed \033[0m"
    #     fi
    # done
else echo -e "\033[31m WRONG ARGUMENT \033[0m"
fi
