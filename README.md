# Syntacore Test Task
## Hardware implementation of Crossbar Device (4 Masters -> 4 Slaves)*

***Реализация устройства cross-bar, обеспечивающее коммутацию между 4-мя Master и 4-мя Slave устройствами**


## Структура репизитория
```
./Quartus_project - папка с проектом для среды Quartus Prime
    Crossbar.qpf - файл проекта
    Crossbar.qsf - файл с настройками для проекта
    ./src/ - папка с исходным кодом проекта
        constrains.sdc - файл с временными характеристиками для проекта
        Control.sv     - исходный код модуля управления между Master и Slave устройствами
        Master.sv      - исходный код модуля Master устройства
        Slave.sv       - исходный код модуля Slave устройства
        top_level      - исходный код модуля верхнего уровня
./Modelsim_project - папка с проектом для среды ModelSim
    Control.sv      - исходный код модуля управления между Master и Slave устройствами
    Master.sv       - исходный код модуля Master устройства
    Slave.sv        - исходный код модуля Slave устройства
    top_level       - исходный код модуля верхнего уровня
    tb_top_level.sv - исходный код тестбенча
    Crossbar.mpf    - файл проекта для среды ModelSim
    wave.do         - файл, для генерация временной диаграммы
    ./work/         - папка, содержащая библиотеки для проекта ModelSim
```
## Описание тестбенча 
### Тестбенч выполняет 3 общие провреки
```
1. 4 Master'а записывают в один Slave
2. 4 Master'а записывают в разные Slave
3. 2 Master'а записывают, а затем 2 другие Master'а считывают
```