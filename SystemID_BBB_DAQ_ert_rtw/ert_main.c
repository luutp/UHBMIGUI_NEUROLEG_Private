/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * File: ert_main.c
 *
 * Code generated for Simulink model 'SystemID_BBB_DAQ'.
 *
 * Model version                  : 1.3
 * Simulink Coder version         : 8.10 (R2016a) 10-Feb-2016
 * C/C++ source code generated on : Fri Aug 11 00:28:19 2017
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include <stdio.h>
#include <stdlib.h>
#include "SystemID_BBB_DAQ.h"
#include "SystemID_BBB_DAQ_private.h"
#include "rtwtypes.h"
#include "limits.h"
#include "linuxinitialize.h"

/* Function prototype declaration*/
void exitTask(int sig);
void terminateTask(void *arg);
void baseRateTask(void *arg);
void subrateTask(void *arg);
volatile boolean_T runModel = true;
sem_t stopSem;
sem_t baserateTaskSem;
pthread_t schedulerThread;
pthread_t baseRateThread;
unsigned long threadJoinStatus[8];
int terminatingmodel = 0;
void baseRateTask(void *arg)
{
  runModel = (rtmGetErrorStatus(SystemID_BBB_DAQ_M) == (NULL));
  while (runModel) {
    sem_wait(&baserateTaskSem);
    SystemID_BBB_DAQ_step();

    /* Get model outputs here */
    runModel = (rtmGetErrorStatus(SystemID_BBB_DAQ_M) == (NULL));
  }

  runModel = 0;
  terminateTask(arg);
  pthread_exit((void *)0);
}

void exitTask(int sig)
{
  rtmSetErrorStatus(SystemID_BBB_DAQ_M, "stopping the model");
}

void terminateTask(void *arg)
{
  terminatingmodel = 1;
  printf("**terminating the model**\n");
  fflush(stdout);

  {
    int ret;
    runModel = 0;
  }

  /* Disable rt_OneStep() here */

  /* Terminate model */
  SystemID_BBB_DAQ_terminate();
  sem_post(&stopSem);
}

int main(int argc, char **argv)
{
  printf("**starting the model**\n");
  fflush(stdout);
  rtmSetErrorStatus(SystemID_BBB_DAQ_M, 0);

  /* Initialize model */
  SystemID_BBB_DAQ_initialize();

  /* Call RTOS Initialization funcation */
  myRTOSInit(0.2, 0);

  /* Wait for stop semaphore */
  sem_wait(&stopSem);
  return 0;
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
