# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    # dut.ui_in.value = 0
    # dut.uio_in.value = 0
    # dut.rst_n.value = 0
    # await ClockCycles(dut.clk, 10)
    # dut.rst_n.value = 1

    # dut._log.info("Test project behavior")

    # # Set the input values you want to test
    # dut.ui_in.value = 20
    # dut.uio_in.value = 30

    # # Wait for one clock cycle to see the output values
    # await ClockCycles(dut.clk, 1)

    # # The following assersion is just an example of how to check the output values.
    # # Change it to match the actual expected output of your module:
    # assert dut.uo_out.value == 50

    # # Keep testing the module by changing the input values, waiting for
    # # one or more clock cycles, and asserting the expected output values.

    # Initialize and Reset
    dut.rst_n.value = 0
    dut.uio_in.value = 0
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    # 1. Start the process (Pulse GO)
    dut.ui_in.value = 10
    dut.uio_in.value = 1  # go = 1
    await ClockCycles(dut.clk, 1)
    
    # 2. Feed more data (GO can stay 0 now)
    dut.uio_in.value = 0  # go = 0
    dut.ui_in.value = 50
    await ClockCycles(dut.clk, 1)
    
    dut.ui_in.value = 20
    await ClockCycles(dut.clk, 1)

    # 3. Pulse FINISH
    dut.uio_in.value = 2  # finish = 1 (bit 1 of uio_in)
    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 1)

    # 4. Check Result
    # Max(50) - Min(10) = 40
    final_range = int(dut.uo_out.value)
    dut._log.info(f"Final Range calculated: {final_range}")
    assert final_range == 40
