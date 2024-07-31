# Single Port RAM

**Description:**
A single port memory is a type of memory that can be accessed by only one device or process at a time. In this type of memory, data can be written and read from the same port but not simultaneously. It is generally used in applications where only one processor is used, and the memory is not required to be accessed by multiple processors simultaneously.

**Features**
o	The design is a single port RAM 
o	The RAM clock frequency is 25 MHz
o	The depth of the RAM is parameterized 
o	The data width is parameterized 
o	Changes in the RAM happen at positive edge of clock 
o	Asynchronous active low reset. On assertion, the data output becomes ‘z’ 
o	The write operation into the RAM is supported. For invalid address, the RAM does nothing  
o	The read operation from the RAM is supported. For invalid address, i.e., address value > that supported by the address width, the invalid address is truncated to fit in the address width and the data read from the RAM will be done using that truncated location
o Simultaneous read and write operation is not supported
