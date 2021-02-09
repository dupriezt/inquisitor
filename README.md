# Inquisitor

Inquisitor is a debugging tool which you point at a test method or custom code. You can then ask questions like: right-click on a method, "What does it return?". Inquisitor will run the execution and answer you with the list. If you see a suspicious value, there's a button to directly open a debugger on the moment that value was captured.

## Installation

**Latest Stable Version**
```Smalltalk
Metacello new
  githubUser: 'dupriezt' project: 'Inquisitor' commitish: 'v1.1.0' path: '';
  baseline: 'Inquisitor';
  load
```

**Bleeding Edge**
```Smalltalk
Metacello new
    baseline: 'Inquisitor';
    repository: 'github://dupriezt/inquisitor';
    load.
```

## Demo

1. Open the Inquisitor workbench UI  
![](https://user-images.githubusercontent.com/32486709/104742583-e7051b00-574a-11eb-9c2d-29209ddfc7cf.jpg)  
Result:  
![](https://user-images.githubusercontent.com/32486709/104742589-e8cede80-574a-11eb-90d2-68f937e9309f.jpg)
2. Create an Inquisitor
    1. On custom code  
    ![](https://user-images.githubusercontent.com/32486709/104742594-ea000b80-574a-11eb-982b-fffb84084915.jpg)
    2. On a test method  
    ![](https://user-images.githubusercontent.com/32486709/104742600-eb313880-574a-11eb-81b9-98d496288fb0.jpg)
3. Set the Inquisitor as "main Inquisitor". The main Inquisitor is the one that will answer questions.  
![](https://user-images.githubusercontent.com/32486709/104742602-ec626580-574a-11eb-8c9a-4cd5be6d0dcc.jpg)
4. Ask a question. For example: right-click on a method and asks what values it returns  
![](https://user-images.githubusercontent.com/32486709/104742606-ed939280-574a-11eb-92f5-2e24dd52e5d0.jpg)
5. Inspect the answer data
    1. Quick-view window of the question
    2. List of the capture points captured by Inquisitor
    3. A playground to play with the capture point list
![](https://user-images.githubusercontent.com/32486709/104742610-eec4bf80-574a-11eb-867a-32a9d386564b.jpg)
6. Open any capture point in a debugger, at the moment it was captured  
![](https://user-images.githubusercontent.com/32486709/104746193-3a796800-574f-11eb-84da-a8e484a18d23.jpg)
![](https://user-images.githubusercontent.com/32486709/104742618-f1271980-574a-11eb-895a-45a83fba3639.jpg)

## Questions currently available

- **Method Return**: "Method, what values do you return?"
- **Hit Check**: "AST node, how many times are you encountered?"
- **Variable History**: "Variable, what values do you take?"
- **Value Check**: "AST node, what is the value of <expression> when you are encountered?"
- **Class Instanciation**: "Class, when are you instanciated?"

