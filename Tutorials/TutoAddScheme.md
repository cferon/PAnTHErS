# Adding a new Homomorphic Encryption scheme to PAnTHErS

This tutorial explains how to integrate a new HE scheme into PAnTHErS.

[TOC]

## Prerequisites

Before the integration, the new HE scheme algorithm must be decomposed into HE Basic, Specific and Atomic functions.

## Adding a new Specific to PAnTHErS

### 1. Get the Specific algorithm template

A template to build a new Specific is available in PAnTHErS source files.

Copy the template file and name it upon your own Specific:

```bash
$> cd /path/to/panthers/
$> cp Templates/template_Specific.sage mySpecific.sage
```
Now edit the file `mySpecific.sage` and adapt it to your own Specific algorithm.

### 2. `make_SpecificName` function
```python
    #Rename the function to match your Specific algorithm name
    #Here the new specific created is named 'MySpecific'
    def make_MySpecific(self) :
        """ Build a SpecificFunction object having :
            - a list of input Parameters
            - a function containing its operations (ope function),
            - a list of output Parameters
            """
        
        #Build a SpecificFunction object named "MySpecific"
        spec = self.builder.specificFunction("MySpecific")

        #Create initial inputs Parameters
        #Here the input parameters are named q1 and q2
        #If an input Parameter can have different type, put "NoType"
        
        #Build q1 Parameter, 
        #its name is "q1"
        #its type is "int"
        #its initial value is 0
        #its dimension is 1,1 (row count, column count)
        #its degree is 0
        q1 = self.builder.parameter("q1","int",0,1,1,0)
        
        #Build q2 Parameter, 
        #its name is "q2"
        #its type is "NoType" (the type can vary depending on the inputs)
        #its initial value is 0
        #its dimension is 1,1 (row count, column count)
        #its degree is 0
        q2 = self.builder.parameter("q2","NoType",0,1,1,0)

        #List here the newly created parameters q1 and q2
        inputs = [q1, q2]
        spec.inputs = inputs

        #Retrieve Atomics that you will use in your Specific
        prodScal = self.finder.atomic(self.allAtomics, "prodScal")
```
### 3. `check_outputs` function

The check_outputs function checks whether the provided outputs are simple strings or actual parameters.

If a string is provided, it is replaced in the `outputs` list by new Parameter object named upon that string value.

```python
        def check_outputs(outputs, count) :
        	 #If a temporary variable is required, you can use the following name generator to avoid name collisions:
              #     "OutSpecName_spec_" + spec.count.str()
                
            if len(outputs) == 0 :
            	
                #No output name or Parameter provided
                #Create outputs Parameters from scratch
                #Here the output parameters are o1 and o2
                
                #Their names are generated using predefined prefixs concatenated with a counter incremented each time this Specific function is called
        
                #Build o1 Parameter, 
                #its name is "OutSpecMySpecific_spec_O1_<Specific_call_counter>"
                #its type is "int"
                #its initial value is 0
                #its dimension is 1,1 (row count, column count)
                #its degree is 0
                o1 = self.builder.parameter("OutSpecMySpecific_spec_O1_" + spec.count.str(),"int",0,1,1,0)
                
                #Build o2 Parameter, 
                #its name is "OutSpecMySpecific_spec_O2_<Specific_call_counter>"
                #its type is "int"
                #its initial value is 0
                #its dimension is 1,1 (row count, column count)
                #its degree is 0
                o2 = self.builder.parameter("OutSpecMySpecific_spec_O2_" + spec.count.str(),"int",0,1,1,0)
                
                #List here newly created output parameters
                outputs = [o1, o2]
                spec.count = spec.count + 1
                spec.outputs = outputs
                return outputs
            else :
                #Replace strings by Parameter objects
                for i in range(len(outputs)):
                    if isinstance(outputs[i], str) :
                        
                        #Build generic Parameter with default values, 
                        #its name is the value provided in outputs[i]
                        #its type is "NoType" (generic type)
                        #its initial value is 0
                        #its dimension is 1,1 (row count, column count)
                        #its degree is 0
                        outputs[i] = self.builder.parameter(outputs[i],"NoType", 0, 1, 1, 0)
                return outputs
```
### 4. `ope` function

The `ope` function contains the list of operations performed by the new Specific algorithm.

```python
        def ope(inputs, outputs = [], count = spec.count) :
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs
            
            #Report your input parameters here
            #The input parameters for the new Specific are q1 and q2
            [q1, q2] = spec.inputs

            #Describe the specific algorithm here using Atomics and/or Specifics
           
        	#Here the two outputs o1 and o2 are computed using Atomics
            
            #First output parameter o1 is the result of q1+q2
            #The Atomic add is used
            [outputs[0]] = add.ope([q1,q2], [outputs[0]])
            
            #Second output parameter o2 is the result of q1*q2
            #The Atomic mult is used
            [outputs[1]] = mult.ope([q1,q2], [outputs[0]])

            spec.outputs = outputs
            return spec.outputs

        spec.ope = ope
        return spec
```


### 5. Integrate your Specific in PAnTHErS library

Edit the `specificfunctioncreator.sage` file.

Register your Specific algorithm in the `SpecificFunctionCreator` class by adding the following line to the `make_all` function:
```python
res = res + [self.make_MySpecific()]
```

Copy the code of your function `make_MySpecific`, and paste it after every other `make_function` functions.

```python
class SpecificFunctionCreator(object):

    def __init__(self, flag = "HEBasic", file = "") :
    #...
    #...
    #...

    def make_all(self) :
        res = []
        res = res + [self.make_addTimes()]
        res = res + [self.make_distriLWE()]
        res = res + [self.make_doubleDistriLWE()]
        #...
        #...
        
        #Register your Specific to the SpecificFunctionCreator
        #Add following line:
        res = res + [self.make_MySpecific()]
        
        return res

    #...
    #...

    def make_addTimes(self) :
    #...
    def make_distriLWE(self) :
   	#...
    #...
    def make_msbToPolynomial(self) :
	#...
    def make_msbToPolynomial(self) :
  	#...
    
    #Here paste the code from the mySpecific.sage file
    def make_MySpecific(self) :
    #... content of mySpecific.sage file
    
```

### 6. Use your Specific in a HE scheme

To have access to your Specific in a HE scheme, you need to declare it by adding the following line in the `__init__` function of the HE scheme class:

```python
self.mySpecific = self.finder.specific(self.heMult.allSpecifics, "mySpecific")
```
Here is an example for the integration of the Specific algorithm `mySpecific` in a scheme `SchemeName` class:

```python
class SchemeName(HEScheme) :
    """ Describe your HE scheme here """

    def __init__(self, listOfParams, listOfSets) :
        self.builder = Builder()
        self.finder = Finder()
        #...
        #...

        #Definition of Atomics and Specifics available in PAnTHErS library
        self.add = self.finder.atomic(self.heKeyGen.allAtomics, "add")
        self.mult = self.finder.atomic(self.heKeyGen.allAtomics, "mult")
        self.sub = self.finder.atomic(self.heKeyGen.allAtomics, "sub")
        #...
        #...

        self.addTimes = self.finder.specific(self.heKeyGen.allSpecifics, "addTimes")
        self.distriLWE = self.finder.specific(self.heKeyGen.allSpecifics, "distriLWE")
        self.powersOf = self.finder.specific(self.heKeyGen.allSpecifics, "powersOf")
        #...
        #...
        
        #Declare here the new Specific algorithm to use it in SchemeName
        self.mySpecific = self.finder.specific(self.heMult.allSpecifics, "mySpecific")
        #...
        #...
```

You can now use and test your new Specific algorithm `MySpecific` with an existing PAnTHErS application. 
However, no theoretical analysis is associated with your algorithm yet. For now, you can only use it for practical executions.

## Create the analysis models for a new Specific

To be able to get theoretical analysis for memory cost and execution time estimations, the Specific algorithm have to be adapted. The algorithm duplication is required and must be integrated with some adaptations to perform the desired analysis process.
This has to be done twice: once for memory consumption analysis and once for computational complexity analysis.

### Specific: Memory consumption analysis

Here are described the steps required for providing memory consumption analysis for the Specific algorithm `MySpecific`.

#### 1. Import the Specific algorithm code

The Specific algorithm code from your file `mySpecific.sage` must be imported in the file `specificfunctionmemorycreator.sage`. This file can be found on PAnTHErS source code:

```bash
/path/to/panthers/Memory/specificfunctionmemorycreator.sage
```

Now edit the file `specificfunctionmemorycreator.sage` to add your own code. Like for [`specificfunctioncreator.sage`](#5.-integrate-your-specific-in-panthers-library), you need to register your algorithm to the `SpecificFunctionMemoryCreator` class by adding the following line to the `make_all` function:

```python
res = res + [self.make_MySpecific()]
```

Then, copy the code of your function `make_MySpecific`, and paste it after every other `make_function` functions.


```python


class SpecificFunctionMemoryCreator(object):

    def __init__(self) :
        #...
        #...

    def make_all(self) :
        res = []
        res = res + [self.make_addTimes()]
        res = res + [self.make_distriLWE()]
        res = res + [self.make_doubleDistriLWE()]
        #...
        #...
        
        #Register your Specific to the SpecificFunctionMemoryCreator
        #Add following line:
        res = res + [self.make_MySpecific()]
        
        return res

    def make_addTimes(self) :
    #...
    def make_distriLWE(self) :
   	#...
    #...
    def make_msbToPolynomial(self) :
	#...
    def make_msbToPolynomial(self) :
  	#...
    
    #Here paste the code from the mySpecific.sage file
    def make_MySpecific(self) :
    #... content of mySpecific.sage file

```

#### 2. Update your Specific algorithm code to evaluate memory consumption

Now from the file `specificfunctionmemorycreator.sage`, edit the code of your `make_MySpecific` function in order to adapt it for memory analysis.

##### 2.1 `make_MySpecific` function
```python
    def make_MySpecific(self) :
        
        #Build a SpecificFunctionMemory object named "MySpecific"
        spec = self.builder.specificFunctionMemory("MySpecific")
        
        #Create a Memory Object used for memory consumption tracking
        spec.memory = Memory()

        #No more changes required for this function
        #...
```
##### 2.2 `ope` function

The `ope` function also need to be updated. 

The prototype of the function must be updated to accept a Memory object:

```python
def ope(inputs, outputs = [], memory = spec.memory, count = spec.count) :
```
You also need to update all the operations performed by Atomics and Specifics. Replace all the calls by their memory analysis counterparts. For example:

```python
[outputs[0]] = add.ope([q1,q2], [outputs[0]])
#Becomes
[outputs[0]] = add.ope([q1,q2], [outputs[0]], memory)
```
> :warning: Ensure that your updated function call matches the parameter order as described in the file `Memory/atomicfunctionmemorycreator.sage`.

At the end of the `ope` function, you need to add the two following lines in oder to keep the Memory object sorted:

```python
spec.memory.allMem = []
memory.sortSpec(spec, spec.name + " : " )
```

The final `ope` function:

```python
        #Update the function prototype to accept a Memory object
        def ope(inputs, outputs = [], memory = spec.memory, count = spec.count) :
           	#...
            
            #Update the add call for its memory analysis counterpart
            [outputs[0]] = add.ope([q1,q2], [outputs[0]], memory)
            
            #Update the mult call for its memory analysis counterpart
            [outputs[1]] = mult.ope([q1,q2], [outputs[0]], memory)

            #Add two lines sort parameters in Memory object
            spec.memory.allMem = []
            memory.sortSpec(spec, spec.name + " : " )
            
            spec.outputs = outputs
            return spec.outputs
```

:warning: **`ope` function: local variables**
Another code update is required if you introduced local variables in your `ope` function.
As they are not automatically tracked by the Memory object, you need to do it manually.

```python
#Local variable example
tmpAdd = self.builder.parameter("TmpVar_add_" + spec.count.str(), "poly", R(0),1,1,0)
tmpMul = self.builder.parameter("TmpVar_mul_" + spec.count.str(), "poly", R(0),1,1,0)

#Register local variables after their creation
memory.add(tmpAdd)
memory.add(tmpMul)
memory.raise_memTmp(tmpAdd)
memory.raise_memTmp(tmpMul)

#...
#function operations
#...

#At the function end, add local variables to global memory
spec.memory.allMem = [tmpAdd, tmpMul]
#...
```


### Specific: Computational complexity analysis

Here are described the steps required for providing computational complexity analysis for the Specific algorithm `MySpecific`.

#### 1. Import the Specific algorithm code

The Specific algorithm code from your file `mySpecific.sage` must be imported in the file `specificfunctioncomplexitycreator.sage`. This file can be found on PAnTHErS source code:

```bash
/path/to/panthers/Complexity/specificfunctioncomplexitycreator.sage
```

Now edit the file `specificfunctioncomplexitycreator.sage` to add your own code. Like for [`specificfunctioncreator.sage`](#5.-integrate-your-specific-in-panthers-library), you need to register your algorithm to the `SpecificFunctionComplexityCreator` class by adding the following line to the `make_all` function:

```python
res = res + [self.make_MySpecific()]
```

Then, copy the code of your function `make_MySpecific`, and paste it after every other `make_function` functions.

```python
class SpecificFunctionComplexityCreator(object):

    def __init__(self) :
        #...
        #...

    def make_all(self) :
        res = []
        res = res + [self.make_addTimes()]
        res = res + [self.make_distriLWE()]
        res = res + [self.make_doubleDistriLWE()]
        #...
        #...
        
        #Register your Specific to the SpecificFunctionComplexityCreator
        #Add following line:
        res = res + [self.make_MySpecific()]
        
        return res

    def make_addTimes(self) :
    #...
    def make_distriLWE(self) :
   	#...
    #...
    def make_msbToPolynomial(self) :
	#...
    def make_msbToPolynomial(self) :
  	#...
    
    #Here paste the code from the mySpecific.sage file
    def make_MySpecific(self) :
    #... content of mySpecific.sage file

```

#### 2. Update your Specific algorithm code to evaluate computational complexity

Now from the file `specificfunctioncomplexitycreator.sage`, edit the code of your `make_MySpecific` function in order to adapt it for computational complexity analysis.

##### 2.1 `make_MySpecific` function
```python
    def make_MySpecific(self) :
        
        #Build a SpecificFunctionComplexity object named "MySpecific"
        spec = self.builder.specificFunctionComplexity("MySpecific")
        
        #Create a Complexity Object used for computational complexity tracking
        spec.complexity = Complexity()

        #No more changes required for this function
        #...
```
##### 2.2 `ope` function

The `ope` function also need to be updated. 

The prototype of the function must be updated to accept a Complexity object:

```python
def ope(inputs, outputs = [], complexity = spec.complexity, count = spec.count) :
```
At the beginning of the `ope` function, add the following line to reinitialize the `spec.complexity` object.

```python
spec.complexity.reset()
```

You also need to update all the operations performed by Atomics and Specifics. Replace all the calls by their computational complexity analysis counterparts. For example:

```python
[outputs[0]] = add.ope([q1,q2], [outputs[0]])
#Becomes
[outputs[0]] = add.ope([q1,q2], [outputs[0]], complexity)
```
> :warning: Ensure that your updated function call matches the parameter order as described in the file `Complexity/atomicfunctioncomplexitycreator.sage`.

At the end of the `ope` function, you need to add the following line in oder to log computational complexity in output file:

```python
complexity.printInFile(spec, spec.name + " ")
```

The final `ope` function:

```python
        #Update the function prototype to accept a Complexity object
        def ope(inputs, outputs = [], complexity = spec.complexity, count = spec.count) :
            spec.complexity.reset()
           	#...
            
            #Update the add call for its computational complexity analysis counterpart
            [outputs[0]] = add.ope([q1,q2], [outputs[0]], complexity)
            
            #Update the mult call for its computational complexity analysis counterpart
            [outputs[1]] = mult.ope([q1,q2], [outputs[0]], complexity)

            #Log computational complexity in output file
            complexity.printInFile(spec, spec.name + " ")
            
            spec.outputs = outputs
            return spec.outputs
```

>:bulb: **`ope` function: loops analysis optimization**
>Analyzing loops can be time consuming. It's possible to optimize their computational complexity analysis process. To do so, you have to retrieve the analysis results for one loop, and then, manually multiply it by the amount of loops that would have been performed.
>
>```python
>#Loop optimization example
>for i in range(10) :
>	[a] = add.ope([a,b], [a], complexity)
>    
>#Becomes
>
>#The factor 10 is provided on the last add operation parameter 
>[a] = add.ope([a,b], [a], complexity, 10)
>```
>

## Scheme integration using PAnTHErS template

### 1. Get the scheme template
A template for a new HE scheme is available in PAnTHErS source files.

Copy the template file and name it upon your own scheme:

```bash
$> cd /path/to/panthers/
$> cp Templates/template_HE_Scheme_Class.sage myScheme.sage
```

Now edit the file `myScheme.sage` and adapt it to your own scheme.

### 2. Class name
```python
#Change class name with your own Scheme name
class MyScheme(HEScheme) :
    """ Describe your HE scheme here """
```
### 3. `__init__` function

```python
    def __init__(self, listOfParams, listOfSets) :
        self.builder = Builder()
        self.finder = Finder()
    
    	#List your input sets here
        #Here the new scheme have a set named R
        [self.R] = listOfSets
        
        
        #List your input parameters here
        #Here the new scheme have two parameters p1 and p2
        [self.p1, self.p2] = self.defineInParams(listOfParams, listOfSets)
        
        #Put back your input parameters list here
    	#Here put back the two parameters p1 and p2
        HEScheme.__init__(self, [self.p1, self.p2], listOfSets)
        
        # ...
        # ... list of Atomics and Specifics available in PAnTHErS ...
        # ...
```

### 4. `defineInParams` function

```python

    def defineInParams(self, listOfParams) :
        """
        Build Parameter objects with input parameters values given in listOfParams
        See Parameter class for a list of all possible build values
        """
        
        #Build two Parameter objects for the parameters p1 and p2

        #Build p1 Parameter from listOfParams[0] (value of p1), 
        #its name is "p1"
        #its type is "int"
        #its dimension is 1,1 (row count, column count)
        p1 = self.builder.parameter("p1", "int", listOfParams[0], 1, 1)
        
        #Build p2 Parameter from listOfParams[1] (value of p2), 
        #its name is "p2"
        #its type is "matrixPoly"
        #its dimension is 2,3 (row count, column count)
        p2 = self.builder.parameter("p2", "matrixPoly", listOfParams[1], 2, 3)

        #Return newly created Parameters
        return [p1, p2]
```
### 5. `keyGen` function

```python

    def keyGen(self) :
        """ Defines HEKeyGen object which has :
            - a list of Parameter inputs
            - a function containing operation of key generation.
            Outputs (keys generated) are put in self.inputs of the HEScheme class.
        """
        
        self.heKeyGen = self.builder.heKeyGen()

        #Here update the type and dimensions of the generated Keys for the scheme
        
        # Private key is a 'poly' of size 1,1 (row count, column count) with initial value of 0
        # Public key is a 'listPoly' of size 1,2 (row count, column count) with initial value of [] (empty list)
        # Evaluation key is a 'listPoly' of size 1,2 (row count, column count) with initial value of [] (empty list)
        self.heKeyGen.inputs = self.inputs
        sk = self.builder.key("PrivateKey", "poly",0,1,1)
        pk = self.builder.key("PublicKey", "listPoly",[],1,2)
        rlk = self.builder.key("EvaluationKey", "listPoly",[],1,2)
        self.heKeyGen.outputs = [sk,pk,rlk]
```
### 6. `keyGen.ope` function

The `keyGen.ope` function describes the keys generation for the new HE scheme. The key generation must be described using exclusively Atomic and Specific algorithms. See [definition of ope function](#4.-`ope`-function) of a new Specific algorithm for more examples.


```python
        def ope(inputs = self.inputs, sets = self.sets, count = self.heKeyGen.count) :
            #Here define all the steps required for keys generation
            #These steps must be described using Atomics and Specifics available in PAnTHErS
            
            #if a temporary variable is required, 
            #you can use the following name generator to avoid name collisions :
            # "TmpHEBasicKeyGen_" + self.heKeyGen.count.str()
            
            #Private Key generation
            [sk] = addTimes.ope([q1,q2,q2], [sk])
            #Put more operations here
            #...
            
            #Public Key generation
            [pk] = addTimes.ope([q1,q2,q2], [pk])
            #Put more operations here
            #...
            
            #Evaluation Key generation
            [rlk] = addTimes.ope([q1,q2,q2], [rlk])
            #Put more operations here
            #...

            #The 3 keys (sk, pk and rlk) are added to the general inputs of the class
            self.inputs = self.inputs + [sk,pk,rlk]
            self.heKeyGen.count = self.heKeyGen.count + 1

        self.heKeyGen.ope = ope
```
### 7. `enc`, `dec`, `addHE` and `multHE` functions

Describe the `enc`, `dec`, `addHE` and `multHE` functions using the same approach as for the `keyGen` function.

```python

    #The same work has to be done for the following functions
    #using Atomics and Specifics available in PAnTHErS
    def enc(self) :
    #describe the encrypt function 
    #...
    def dec(self) :
    #describe the decrypt function 
    #...
    def addHE(self) :
    #describe the Homomorphic Addition function 
    #...
    def multHE(self) :
    #describe the Homomorphic Multiplication function 
    #...
```
### 8. `depth` function

```python

    def depth(self) :
        """Optional: calculates multiplicative depth of the scheme (thanks to a pre-calculated equation) """
        res = 0

        #Describe depth calculation here (without using Atomics or Specifics)

        return res
```
### 9. `__repr__` function

```python

	#Here return the Name of the class
    def __repr__(self):
        return "MyScheme"
```


## Create the analysis models for a new HE Scheme

To be able to get theoretical analysis for memory cost and execution time estimations, the new HE Scheme have to be adapted. The scheme duplication is required and must be adaptated to perform the desired analysis process.
This has to be done twice: once for memory consumption analysis and once for computational complexity analysis.

### HE scheme: Memory consumption analysis

Here are described the steps required for providing memory consumption analysis for the HE Scheme `MyScheme`, defined in [previous parts](#scheme-integration-using-panthers-template).

#### 1. Duplicate the HE Scheme source file

Your HE scheme source file `myScheme.sage` must be duplicated. Here we duplicate it under the name of `mySchemeMemory.sage`, the duplicated file is placed in PAnTHErS source `Memory` folder.

```bash
$> cd /path/to/panthers/
$> cp myScheme.sage Memory/mySchemeMemory.sage
```

Now edit the file `mySchemeMemory.sage` to adapt the code for memory analysis. 

#### 2. Update your HE scheme code to evaluate memory consumption

Now from the file `mySchemeMemory.sage`, edit the code of your HE scheme in order to adapt it for memory consumption analysis.

##### 2.1 Class name
Update your class name to `MySchemeMemory`, also, make it inherit from `HESchemeMemory`.
```python
#Change class name
class MySchemeMemory(HESchemeMemory) :
```
##### 2.2 `__init__` function
At the beginning of the `__init__` function, you must declare a `Memory` object that will be used to track memory consumption.

```python
self.memory = Memory(flag, file)
```
You have to change the call to `HEScheme.__init__` to `HESchemeMemory.__init__`.
```python
HEScheme.__init__(self, [self.p1, self.p2], listOfSets)
#Becomes
HESchemeMemory.__init__(self, [self.p1, self.p2], listOfSets, self.memory)
```
At last, you must declare the module of your HE scheme to the `Memory` object. The module is taken from the input parameters. Here the parameter `p1` is declared as the module for the HE scheme.

```python
self.memory.module = self.p1
```

Here is the resulting `__init__` function.
```python
    def __init__(self, listOfParams, listOfSets) :
        self.builder = Builder()
        self.finder = Finder()
        
        #Add a Memory object to track memory consumption
        self.memory = Memory(flag, file)
    
    	#...
        
        #Change HEScheme to HESchemeMemory
        HESchemeMemory.__init__(self, [self.p1, self.p2], listOfSets, self.memory)
        
        #Define scheme module in Memory object
        #The module is taken from input parameters
        self.memory.module = self.p1
        
        # ...
```

##### 2.3 `keyGen` function

You need to change the line responsible of the creation of the `heKeyGen` object. The type of this object changes from `HEKeyGen` to `HEKeyGenMemory`.

```python
self.heKeyGen = self.builder.heKeyGen()
#Becomes
self.heKeyGen = self.builder.heKeyGenMemory()
```
Rigth after that line, you need to build a `Memory` object for the new `HEKeyGenMemory` object.

```python
self.heKeyGen.memory = Memory(flag, file)
```

Here is the resulting `keyGen` function.
```python

    def keyGen(self) :
        
        #Update the builder to create a HEKeyGenMemory object
        self.heKeyGen = self.builder.heKeyGenMemory()
        #Create the associated Memory object
        self.heKeyGen.memory = Memory(flag, file)

        #...
        
```
##### 2.4 `keyGen.ope` function

Retrieve the `Memory` object at the beginning of the `ope` function.
```python
memory = self.memory
```

Like for the [Specific algorithm memory analysis function](#2.-update-your-specific-algorithm-code-to-evaluate-memory-consumption), the Specific and Atomic algorithm calls used in the `keyGen.ope` function need to be replaced by their memory consumption analysis couterparts. For example:

```python
[sk] = addTimes.ope([q1,q2,q2], [sk])
#Becomes
[sk] = addTimes.ope([q1,q2,q2], [sk], memory)
```

>⚠️ Ensure that your updated function call matches the parameter order as described in the files `Memory/atomicfunctionmemorycreator.sage` and `Memory/specificfunctionmemorycreator.sage`.
>

At the end of the function, add some lines of code to keep track of memory consumption. You first need to report there the ouput parameters (as the `keyGen.ope` function *stores* its outputs in the inputs, the inputs are referenced here).

```python
memory.sortHEBasic(self.heKeyGen, "KeyGen : ", self.inputs)
```
Then, add the two following lines to keep memory object updated.
```python
self.heKeyGen.memory = memory
self.memory.update(memory)
```

Here is the resulting `keyGen.ope` function.
```python
        def ope(inputs = self.inputs, sets = self.sets, count = self.heKeyGen.count) :
        	#Retrieve the Memory object
        	memory = self.memory
        	
            
            #Private Key generation
            #Update addTimes with its memory consumption analysis couterpart
            [sk] = addTimes.ope([q1,q2,q2], [sk], memory)
            #...
            
            #Public Key generation
            #Update addTimes with its memory consumption analysis couterpart
            [pk] = addTimes.ope([q1,q2,q2], [pk], memory)
            #...
            
            #Evaluation Key generation
            #Update addTimes with its memory consumption analysis couterpart
            [rlk] = addTimes.ope([q1,q2,q2], [rlk], memory)
            #...

            
            #Add this line to keep memory object sorted
            #For the keyGen.ope only, report the inputs on last parameter
            memory.sortHEBasic(self.heKeyGen, "KeyGen : ", self.inputs)
            
            #Add the two following lines to keep track of memory consumption
            self.heKeyGen.memory = memory
            self.memory.update(memory)
```

:warning: **`keyGen.ope` function: local variables**
Another code update is required if you introduced local variables in your `keyGen.ope` function.
As they are not automatically tracked by the Memory object, you need to do it manually.

```python
#Local variable example
tmpAdd = self.builder.parameter("TmpVar_add_" + spec.count.str(), "poly", R(0),1,1,0)
tmpMul = self.builder.parameter("TmpVar_mul_" + spec.count.str(), "poly", R(0),1,1,0)

#Register local variables after their creation
memory.add(tmpAdd)
memory.add(tmpMul)
memory.raise_memTmp(tmpAdd)
memory.raise_memTmp(tmpMul)

#...
#function operations
#...

#At the function end, add local variables to the existing inputs
memory.sortHEBasic(self.heKeyGen, "KeyGen : ", self.inputs + [tmpAdd, tmpMul])
#...
```

##### 2.5 `enc`, `dec`, `addHE` and `multHE` functions

Describe the `enc`, `dec`, `addHE` and `multHE` functions using the same approach as for the `keyGen` function.

However, be sure to adapt the process for each function. For example, in the **`enc`** function, create a **`heEnc`** object of type **`HEEncMemory`**.
```python
def enc(self) :
		#Update the builder to create a HEEncMemory object
        self.heEnc = self.builder.heEncMemory()
        #Create the associated Memory object
        self.heEnc.memory = Memory(flag, file)

```
And so on for each following functions.
```python
    def enc(self) :
    #describe the encrypt function 
    #...
    def dec(self) :
    #describe the decrypt function 
    #...
    def addHE(self) :
    #describe the Homomorphic Addition function 
    #...
    def multHE(self) :
    #describe the Homomorphic Multiplication function 
    #...
```

>:warning: At the end of each `functionHE.ope` function, take care to report the ouput parameters and every local variable you may have created. For example for the `enc` function:
>
>```python
>memory.sortHEBasic(self.heEnc, "MyFunction: ", self.outputs + [tmp1, tmp2, tmpN, ...])
>```
>

##### 2.6 `__repr__` function

```python

	#Here return the Name of the class
    def __repr__(self):
        return "MySchemeMemory"
```

### HE scheme: computational complexity analysis

Here are described the steps required for providing computational complexity analysis for the HE Scheme `MyScheme`, defined in [previous parts](#scheme-integration-using-panthers-template).

#### 1. Duplicate the HE Scheme source file

Your HE scheme source file `myScheme.sage` must be duplicated. Here we duplicate it under the name of `mySchemeComplexity.sage`, the duplicated file is placed in PAnTHErS source `Complexity` folder.

```bash
$> cd /path/to/panthers/
$> cp myScheme.sage Complexity/mySchemeComplexity.sage
```

Now edit the file `mySchemeComplexity.sage` to adapt the code for computational complexity analysis. 

#### 2. Update your HE scheme code to evaluate computational complexity

Now from the file `mySchemeComplexity.sage`, edit the code of your HE scheme in order to adapt it for computational complexity analysis.

##### 2.1 Class name
Update your class name to `MySchemeComplexity`, also, make it inherit from `HESchemeComplexity`.
```python
#Change class name
class MySchemeComplexity(HESchemeComplexity) :
```
##### 2.2 `__init__` function

You must update the `__init__` function prototype to allow a `Complexity` object as input parameter.

```python
def __init__(self, listOfParams, listOfSets, flag = "HEBasic", file = "", complexity = Complexity()) :
```

You have to change the call to `HEScheme.__init__` to `HESchemeComplexity.__init__`.
```python
HEScheme.__init__(self, [self.p1, self.p2], listOfSets)
#Becomes
HESchemeComplexity.__init__(self, [self.p1, self.p2], listOfSets, complexity)
```


Here is the resulting `__init__` function.
```python
    def __init__(self, listOfParams, listOfSets, flag = "HEBasic", file = "", complexity = Complexity()) :
        self.builder = Builder()
        self.finder = Finder()

    	#...
        
        #Change HEScheme to HESchemeComplexity
        HESchemeComplexity.__init__(self, [self.p1, self.p2], listOfSets, complexity)
        
        # ...
```

##### 2.3 `keyGen` function

You need to change the line responsible of the creation of the `heKeyGen` object. The type of this object changes from `HEKeyGen` to `HEKeyGenComplexity`.

```python
self.heKeyGen = self.builder.heKeyGen()
#Becomes
self.heKeyGen = self.builder.heKeyGenComplexity()
```
Rigth after that line, you need to build a `Complexity` object for the new `HEKeyGenComplexity` object.

```python
self.heKeyGen.complexity = Complexity(flag, file)
```

Here is the resulting `keyGen` function.
```python

    def keyGen(self) :
        
        #Update the builder to create a HEKeyGenComplexity object
        self.heKeyGen = self.builder.heKeyGenComplexity()
        #Create the associated Complexity object
        self.heKeyGen.complexity = Complexity(flag, file)

        #...
        
```
##### 2.4 `keyGen.ope` function

You must update the `keyGen.ope` function prototype to allow a `Complexity` object as input parameter.

```python
def ope(inputs = self.inputs, sets = self.sets, complexity = self.heKeyGen.complexity) :
```

At the beginning of the `keyGen.ope` function add the following line to reset the complexity object:
```python
self.heKeyGen.complexity.reset()
```

Like for the [Specific algorithm memory analysis function](#2.-update-your-specific-algorithm-code-to-evaluate-memory-consumption), the Specific and Atomic algorithm calls used in the `keyGen.ope` function need to be replaced by their computational complexity analysis couterparts. For example:

```python
[sk] = addTimes.ope([q1,q2,q2], [sk])
#Becomes
[sk] = addTimes.ope([q1,q2,q2], [sk], complexity)
```

>⚠️ Ensure that your updated function call matches the parameter order as described in the files `Complexity/atomicfunctioncomplexitycreator.sage` and `Complexity/specificfunctioncomplexitycreator.sage`.
>

At the end of the function, add the following line to log  computational complexity information in output file.

```python
complexity.printInFile(self.heKeyGen, "KeyGen ")
```

Here is the resulting `keyGen.ope` function.
```python
        def ope(inputs = self.inputs, sets = self.sets, complexity = self.heKeyGen.complexity) :
        	#Reset complexity object
        	self.heKeyGen.complexity.reset()
        	
            
            #Private Key generation
            #Update addTimes with its computational complexity analysis couterpart
            [sk] = addTimes.ope([q1,q2,q2], [sk], complexity)
            #...
            
            #Public Key generation
            #Update addTimes with its computational complexity analysis couterpart
            [pk] = addTimes.ope([q1,q2,q2], [pk], complexity)
            #...
            
            #Evaluation Key generation
            #Update addTimes with its computational complexity analysis couterpart
            [rlk] = addTimes.ope([q1,q2,q2], [rlk], complexity)
            #...

            
            #Add this line to log computational complexity data to output file
            complexity.printInFile(self.heKeyGen, "KeyGen ")
```

##### 2.5 `enc`, `dec`, `addHE` and `multHE` functions

Describe the `enc`, `dec`, `addHE` and `multHE` functions using the same approach as for the `keyGen` function.

However, be sure to adapt the process for each function. For example, in the **`enc`** function, create a **`heEnc`** object of type **`HEEncComplexity`**.
```python
def enc(self) :
		#Update the builder to create a HEEncComplexity object
        self.heEnc = self.builder.heEncComplexity()
        #Create the associated Complexity object
        self.heEnc.complexity = Complexity(flag, file)

```
And so on for each following functions.
```python
    def enc(self) :
    #describe the encrypt function 
    #...
    def dec(self) :
    #describe the decrypt function 
    #...
    def addHE(self) :
    #describe the Homomorphic Addition function 
    #...
    def multHE(self) :
    #describe the Homomorphic Multiplication function 
    #...
```

>:warning: At the end of each `functionHE.ope` function, take care to report the related function call to log the results. For example for the `enc` function:
>
>```python
>complexity.printInFile(self.heEnc, "Enc ")
>```
>

##### 2.6 `__repr__` function

```python

	#Here return the Name of the class
    def __repr__(self):
        return "MySchemeComplexity"
```


## Adding the new scheme to PAnTHErS graphical interface

To use your new HE scheme on PAnTHErS graphical interface, you need to manually add it in the source files.

### In `const_id.py` file

Add a global identifier for your scheme in the file `const_id.py`.
>:warning: Beware not to choose an identifier already affected to an existing scheme. It is recommended to use the value of the highest known scheme ID and increment it by one for your own scheme ID.
>

For example, for the application `MyScheme`, create a new global identifier called `MYSCHEME_ID`:

```python
MYSCHEME_ID = 3
```

In the `getSchemeName` function, add the code required to find the name of the new scheme from its global identifier: 
```python
	elif scheme == MYSCHEME_ID :
		schemeName = "myScheme"
```



### In `Interface/interface.py` file

In the file `Interface/interface.py`, add to the `__init__` function:

```python
# "MyScheme" = scheme name
# MYSCHEME_ID = global identifier for MyScheme
#2 = nbOfParams (for the two params p1 and p2)
#["p1", "p2"] = varying input parameters names of current scheme
self.myScheme = SchemeInterface(self.schemeFrame, self.paramFrame, "MyScheme", MYSCHEME_ID, 2, ["p1", "p2"], self.nbOfRow)
self.updateNbOfRow(self.myScheme)
```

Also add your scheme to the list `schemeList`:
```python
#Add self.myScheme in self.schemeList     
self.schemeList = [self.fv, self.yashe, self.fntru, self.myScheme] 
```


In the function `defaultValues`, add the default values for the varying input parameters of your scheme. These values will be used when clicking on the `Default Value` button of the graphical interface.
```python
if analyzeOrExplo == ANALYZE_ID:
	#Default values for analysis
	#....
	self.myScheme.params[0].forDefaultButton = [100,300,10,100] #p1
	self.myScheme.params[1].forDefaultButton = [2,40,2,2] #p2
else:
	#Default values for exploration
	#...
	self.myScheme.params[0].forDefaultButton = [2,1000,1,2] #p1
	self.myScheme.params[1].forDefaultButton = [2,1000,1,2] #p2
```

### In `Analyse/analyse.py` file

At the beginning of the file `Analyse/analyse.py`, add the lines:

```python
load("../myScheme.sage")         
load("../Memory/mySchemeMemory.sage")        
load("../Complexity/mySchemeComplexity.sage")
```

### In every `Analyse/appli_*.sage` files

In every function named `computeApplication*`, add the following condition to test if the given scheme is an instance of `myScheme`, and then define the type of parameter used for ciphertexts :
```python
		#Here MyScheme ciphertexts are matrixPoly
		if isinstance(scheme, MyScheme) or isinstance(scheme, MySchemeComplexity) or isinstance(scheme, MySchemeMemory) :
        		typeCipher = "matrixPoly"
```

### In `Analyse/parameterschoice.sage` file


Create a function named `chooseMySchemeParameter (p1, p2, secu = 80)`.
Here we provided two input parameters (p1 and p2).
>:warning: only provide input parameters that can be varied (during an analysis).
>

The purpose of this function is to generate/create the parameters `listOfParams` and `listOfSets`. Parameters that can be varied are provided as input parameters. Other fixed value parameters required by the HE scheme have to be generated/initialized here.
> :bulb: You can see examples in other `choose*Parameter` functions already available in this file.
> 


In the function named `chooseParameter`, add a condition with your own scheme identifier:

```python
	elif scheme == MYSCHEME_ID :
		#Here MyScheme takes 2 input parameters
        if len(params) != 2 :
            raise Exception("chooseParameter : there is not 2 parameters (but {}) in params".format(len(params)))

		#Retrieve scheme parameters here
        p1 = params[0].currentValue
        p2 = params[1].currentValue

		#call chooseMySchemeParameter with p1 and p2
        return chooseMySchemeParameter(p1,p2,secu)
```


In the function `createSchemeObject`, add a conditional branch for your scheme. The three lower conditional branches are required to generate an appropriate HE scheme object depending on the kind analysis chosen. 
```python
	elif scheme == MYSCHEME_ID :
        if whichAnalysis == EXECUTION_ID : #execution
            return MyScheme(params, sets, "HEBasic", "")
        elif whichAnalysis == COMPLEXITY_ANALYSIS_ID : #complexity
            return MySchemeComplexity(params, sets, "HEBasic", "")
        elif whichAnalysis == MEMORY_ANALYSIS_ID : #memory cost
            return MySchemeMemory(params, sets, "HEBasic", "")
```





Have fun! :wink:



This file is distributed under the [CeCILL 2.1 License](http://www.cecill.info).
See the License.txt file for more details.

© 2018 Cyrielle Feron - ENSTA Bretagne












