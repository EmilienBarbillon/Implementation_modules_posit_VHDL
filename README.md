Implementation of VHDL modules for posit arithemetic 
====================================================


A new data type called a posit is designed as a direct drop-in replacement for IEEE Standard 754 floating-point numbers (floats). Unlike earlier forms of universal number (unum) arithmetic, posits do not require interval arithmetic or variable size operands; like floats, they round if an answer is inexact. However, they provide compelling advantages over floats, including larger dynamic range, higher accuracy, better closure, bitwise identical results across systems, simpler hardware, and simpler exception handling. The project would consist of implementing some of the basic modules (adders, multipliers) in VHDL or using any other Hardware Description Language. 



### 1. Posit design #

* 2 Parameters :    
  -   _**n**_ : size of posit    
  -   _**es**_ : size of exponent


![](src/Design_posit.PNG)

* Bit fields :
    
    -   _**Sign bit**_ :  
      -  	if '0' ==> Positive number   
      -  	if '1' ==> Negative number
      
    -   _**Regime bits**_ :  
      -  	/r : '1'   -->   k = -m      m : nb of '0'   
      -  	/r : '0'   -->   k= m-1      m: nb of '1'
	   
    -   _**Exponent bits**_ :  
      -  	e  : value of exponent 
	    
    -   _**Fraction bits**_ :  
      -  	fract  : value of fraction
      
### 2. Value of Posit #

![](src/compute_posit_value.PNG)

### 2. Implementation of VHDL modules  #

The modules VHDL "Posit extraction" & "Multiplier" are based on algotrithms presented in : 

_**"Deep Positron: A Deep Neural Network Using the Posit Number System"**_
_Zachariah Carmichael, Hamed F. Langroudi, Char Khazanov, Jeffrey Lillie,
John L. Gustafson, Dhireesha Kudithipudi
Neuromorphic AI Lab, Rochester Institute of Technology, NY, USA
National University of Singapore, Singapore_

Below you'll find algorithms used to implement modules.

#### 2.1. Posit extraction 

![](src/algo_extraction.PNG)*

In our extraction module, we added tow more output to check if the posit is __Zero__ ("000...000") ou __Not a Real__ ("100...000").
Names of those output are _zero_ of __Zero__ and _Nar_ for __Not a Real__.

We have created a module CLZ (_LZD - line 7_ in the algortihm above) which allows to count a sequence of '0' until the first one. This module can count until 32 zeros. And to make the shifting  

<!---#### 2.2. Multiplier--->  

<!---#### 2.3. Pack Posit --->



				

  
