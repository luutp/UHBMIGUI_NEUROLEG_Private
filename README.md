<<<<<<< HEAD
# UHBMIGUI_NEUROLEG

This is a library to process EEG data acquired in the project Neuro Leg

## Getting Started

1. Create 2 folders for storing raw data and processed data. e.g. "Raw Data", "Process Data"
2. Copy raw data files (.mat files) and captrack files (.bvct) to the Raw Data.
3. Run the UHBMIGUI_NEUROLEG matlab script to open the GUI.
4. At the GUI interface. Select Setting Menu -> Set Data Folder...
5. A small GUI will appear. Select "Raw Data" folder path for Raw Mat text box and "Process Data" folder path for Process Mat.
6. Save the setting. This setting will save "Raw Data" and "Process Data" folders as your default when the main GUI is run next times.
7. Go back to the main GUI (UHBMIGUI_NEUROLEG). Go to Function List and run Makeelecfile function to create .elc file for electrode positions.
8. Run MakeEEGfile. This function will combine EEG file and .elc file and create new file in the "Process Data" folder.
9. Data processing functions in Function List tree will run and update files in the "Process Data" Folder.

External:

1. uhlib. Copy uhlib folder and place at the same level with UHBMIGUI_NEUROLEG

2. EEGLAB. Add eeglab to matlab path.

## Regarding Github:
* Make sure you do this tutorial (https://try.github.io/levels/1/challenges/1)
* Create your own branch (e.g. Open Git shell -> git checkout -b sho)

Following steps are the steps you should take while coding:

1. Write code on your branch

2. Commit frequently

  e.g. (If you are using Git Shell)

  You wrote EMG analysis in EMGmodule.m

  ```
  git add EMGmodule.m
  git commit -m "Added EMG analysis (more description is good)"
  ```

3. Make sure to push your changes at the end of the day to your branch

  (If you are woking on branch called "sho")

  ```
  git push origin sho
  ```

4. We gonna only merge into master occasionally

5. Ask Sho for merging to master or any other issue you face


### Prerequisities

What things you need to install the software and how to install them

```
Give examples
```

### Installing

A step by step series of examples that tell you have to get a development env running

Stay what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* MATLAB

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags).

## Authors

* **Trieu Phat Luu** - *Initial work* (https://github.com/trieuphatluu)
* **Sho Nakagome** - *Git management* (https://github.com/shonakagome)
* **Justin Brantley** - *Leading project* ()
* **Fangshi Zhu** - *Awesome Nice Looking Guy* ()

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone who's code was used
* Inspiration
* etc
=======
# UHBMIGUI_NEUROLEG_Private
>>>>>>> 08061980a2f85821a2a31e00d2207cee70f2ab2a
