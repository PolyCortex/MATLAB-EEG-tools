# SleepEEG

##  Open-source Library Directory

1.  **PSGread30sEpoch.m** - Selects a short section of physionet EEG recording, displays its spectrogram
2.  **PSGreadWholeNight.m** - Selects a large section of physionet EEG recording, displays its spectrogram  
3.  **PSGanalyse.m** - Provides whole night frequency bands spectral power distributions for 30 seconds epochs
4.  **genData.m** - Generates 30s epochs spectrogram images datasets from all sleep stages
5.  **PSGreadMuse1.m** - Reads muse-lsl exported data 
6.  **PSGreadMuse2.m** - Reads muse monitor exported data	

##  Library Description

There are concrete applications to signal features extraction and classification with many carrying clinical implications.  One such application, is the study of sleep.  Sleep can be described as featuring several stages which are defined by EEG signal behavior in the time and the frequency domain.  Interestingly, sleep stages have well defined physiological and cognitive attributes.  For instance, normal wakefulness is characterized by activation of the prefrontal cortex [1, 2], which allows attention dependant reactivation of neural representations such as memory recall of knowledge and experience, and voluntary motor control [3-6].  In contrast, dreaming during sleep involves a deactivation of the prefrontal cortex, the accompanying loss of voluntary control and self-reflective awareness and the preservation of perception [2, 7].  Dreaming consciousness is further differentiated from waking consciousness by a shift in neuromodulation from wakeful aminergic dominance to dream cholinergic dominance [2, 8, 9].

![Figure 6](https://user-images.githubusercontent.com/35876258/56073546-174ca800-5d74-11e9-9bdd-269b8203d9b3.png)

*Figure 1 Dreaming brain PFC deactivation and cholinergic neurotransmission (modified from Hobson, 2009)*

The physiology of sleep provides a window into psychiatric and neurological disorders.  In depression, decreased dreaming latency can be observed and some interventions have been directed at enhancing aminergic neuromodulation [8, 10].  A manifestation of Alzheimer’s disease, which has been linked with cholinergic system degradation, is sleep fragmentation [11, 12].  While specific guidelines are widely used and establish the rules that allow the manual classification of sleep, other approaches to the study of sleep have been proposed including multitaper spectral analysis [13].  A large sleep database is available online and provides stage labeled sleep data (https://www.physionet.org/physiobank/database/sleep-edfx/) [14, 15].  As a result, it was possible for our team to study and generate representations of sleep stages from a single EEG derivation. For each sleep stage, whole night frequency bands spectral power distributions for 30 seconds epochs can be visualised (**PSGanalyse.m**).  A simple feature-based classifier was built from static data frequency bands distributions (**PSGanalyse.m**).

![StagesDistributions](https://user-images.githubusercontent.com/35876258/56073590-ef117900-5d74-11e9-8f4d-13d2a17a446c.png)

*Figure 2 Whole night 30 seconds epochs frequency bands spectral power distributions*

![Figure 7](https://user-images.githubusercontent.com/35876258/56073615-444d8a80-5d75-11e9-9c3f-fc1514ddf4b6.png)

*Figure 3 REM and N3 sleep stage frequency bands distributions and 30 seconds epoch REM and N3 classifications*

Spectrograms can also be generated and visualised in 3D from 30 second epochs.  An algorithm was developed towards obtaining all 30s epochs spectrogram images from all sleep stages (**genData.m**).  Approaches which achieved classification of seconds-scale epoch spectrogram images using machine learning techniques such as convolutional neural networks have also demonstrated that only a single EEG derivation is needed to achieve state of the art automatic sleep stage classification [16].

![spectrograms](https://user-images.githubusercontent.com/35876258/56073645-a3130400-5d75-11e9-8185-183de9b0f20d.png)

*Figure 4 Sleep stages 30s epoch 3D spectrograms*

<img width="727" alt="fasafs" src="https://user-images.githubusercontent.com/35876258/56073697-5da30680-5d76-11e9-8958-6327b98ee5dc.png">

*Figure 5 30s epoch spectrogram images dataset generation*

![Figure 8](https://user-images.githubusercontent.com/35876258/56073725-ad81cd80-5d76-11e9-94b1-e2c1857e7e82.png)

*Figure 6 Whole night hypnogram, time domain EEG signal and 3D spectrogram*

With more optimizations and Muse device sleep data acquisition and labelling, it is likely that the software that drives MindPong (https://github.com/PolyCortex/MindPong) could be used for online sleep classification.  Live sleep monitoring could allow us to gain a greater appreciation for cognitive and physiological changes associated with mental health disorders and contribute to the development of new prevention and treatment methods.  Moreover, the classified signals could be used to automatically replicate both the experimental and clinical effects of physical interventions which are currently performed manually.  For example, there has been evidence suggesting that auditory stimulation during sleep can yield cognitive improvements in adults [17, 18]. 

##  References

1.	Edelman, G.M., Naturalizing consciousness: a theoretical framework. Proceedings of the National Academy of Sciences, 2003. 100(9): p. 5520-5524.
2.	Hobson, J.A., REM sleep and dreaming: towards a theory of protoconsciousness. Nat Rev Neurosci, 2009. 10(11): p. 803-13.
3.	Goldman-Rakic, P.S., Architecture of the prefrontal cortex and the central executive. Ann N Y Acad Sci, 1995. 769: p. 71-83.
4.	Koechlin, E., Prefrontal executive function and adaptive behavior in complex environments. Current opinion in neurobiology, 2016. 37: p. 1-6.
5.	Tomita, H., et al., Top-down signal from prefrontal cortex in executive control of memory retrieval. Nature, 1999. 401(6754): p. 699.
6.	Huth, A.G., et al., A continuous semantic space describes the representation of thousands of object and action categories across the human brain. Neuron, 2012. 76(6): p. 1210-1224.
7.	Muzur, A., E.F. Pace-Schott, and J.A. Hobson, The prefrontal cortex in sleep. Trends in cognitive sciences, 2002. 6(11): p. 475-481.
8.	Hobson, J.A., The dream drugstore : chemically altered states of consciousness. 2001, Cambridge, Mass.: MIT Press. xv, 333 p.
9.	Rasch, B. and J. Born, About sleep's role in memory. Physiological reviews, 2013. 93(2): p. 681-766.
10.	Cartwright, R.D., The twenty-four hour mind: The role of sleep and dreaming in our emotional lives. 2010: Oxford University Press.
11.	Lim, A.S., et al., Sleep fragmentation and the risk of incident Alzheimer's disease and cognitive decline in older persons. Sleep, 2013. 36(7): p. 1027-1032.
12.	Kar, S., et al., Interactions between β-amyloid and central cholinergic neurons: implications for Alzheimer's disease. Journal of Psychiatry & Neuroscience, 2004.
13.	Prerau, M.J., et al., Sleep neurophysiological dynamics through the lens of multitaper spectral analysis. Physiology, 2016. 32(1): p. 60-92.
14.	Kemp, B., et al., Analysis of a sleep-dependent neuronal feedback loop: the slow-wave microcontinuity of the EEG. IEEE Transactions on Biomedical Engineering, 2000. 47(9): p. 1185-1194.
15.	Goldberger, A.L., et al., PhysioBank, PhysioToolkit, and PhysioNet: components of a new research resource for complex physiologic signals. Circulation, 2000. 101(23): p. e215-e220.
16.	Vilamala, A., K.H. Madsen, and L.K. Hansen. Deep convolutional neural networks for interpretable analysis of EEG sleep stage scoring. in 2017 IEEE 27th International Workshop on Machine Learning for Signal Processing (MLSP). 2017. IEEE.
17.	Papalambros, N.A., et al., Acoustic enhancement of sleep slow oscillations and concomitant memory improvement in older adults. Frontiers in human neuroscience, 2017. 11: p. 109.
18.	Ngo, H.-V.V., et al., Auditory closed-loop stimulation of the sleep slow oscillation enhances memory. Neuron, 2013. 78(3): p. 545-553.


