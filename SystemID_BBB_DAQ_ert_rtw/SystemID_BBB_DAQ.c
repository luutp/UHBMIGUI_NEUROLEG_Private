/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * File: SystemID_BBB_DAQ.c
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

#include "SystemID_BBB_DAQ.h"
#include "SystemID_BBB_DAQ_private.h"

/* Real-time model */
RT_MODEL_SystemID_BBB_DAQ_T SystemID_BBB_DAQ_M_;
RT_MODEL_SystemID_BBB_DAQ_T *const SystemID_BBB_DAQ_M = &SystemID_BBB_DAQ_M_;

/* Model step function */
void SystemID_BBB_DAQ_step(void)
{
  /* S-Function (armcortexa_pwm_sfcn): '<Root>/PWM' incorporates:
   *  Constant: '<Root>/Constant'
   */
  MW_pwmWrite(SystemID_BBB_DAQ_ConstP.PWM_p1, SystemID_BBB_DAQ_P.Constant_Value);
}

/* Model initialize function */
void SystemID_BBB_DAQ_initialize(void)
{
  /* Registration code */

  /* initialize error status */
  rtmSetErrorStatus(SystemID_BBB_DAQ_M, (NULL));

  /* Start for S-Function (armcortexa_pwm_sfcn): '<Root>/PWM' */
  MW_pwmInit(SystemID_BBB_DAQ_ConstP.PWM_p1, 100.0, 1U);
}

/* Model terminate function */
void SystemID_BBB_DAQ_terminate(void)
{
  /* Terminate for S-Function (armcortexa_pwm_sfcn): '<Root>/PWM' */
  MW_pwmTerminate(SystemID_BBB_DAQ_ConstP.PWM_p1);
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
