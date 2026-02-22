<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The range finder saves the maximum and minimum values of the stream
of data within two registers, and outputs the range between them. The
valid bits of data occur between go and finish being asserted, and error
is asserted if the protocol is not followed.

## How to test

Send data sequentially through data_in, starting by asserting a go signal and
ending with a finish signal. Once done sending data, check range to make
sure the value is as expected and that the error signal is not asserted.

## External hardware

None
