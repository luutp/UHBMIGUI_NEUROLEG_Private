/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * File: SystemID_BBB_DAQ.h
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

#ifndef RTW_HEADER_SystemID_BBB_DAQ_h_
#define RTW_HEADER_SystemID_BBB_DAQ_h_
#include <stddef.h>
#ifndef SystemID_BBB_DAQ_COMMON_INCLUDES_
# define SystemID_BBB_DAQ_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "MW_pwm_lct.h"
#endif                                 /* SystemID_BBB_DAQ_COMMON_INCLUDES_ */

#include "SystemID_BBB_DAQ_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

/* Constant parameters (auto storage) */
typedef struct {
  /* Expression: pin
   * Referenced by: '<Root>/PWM'
   */
  uint8_T PWM_p1[6];
} ConstP_SystemID_BBB_DAQ_T;

/* Parameters (auto storage) */
struct P_SystemID_BBB_DAQ_T_ {
  real_T Constant_Value;               /* Expression: 0.5
                                        * Referenced by: '<Root>/Constant'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_SystemID_BBB_DAQ_T {
  const char_T *errorStatus;
};

/* Block parameters (auto storage) */
extern P_SystemID_BBB_DAQ_T SystemID_BBB_DAQ_P;

/* Constant parameters (auto storage) */
extern const ConstP_SystemID_BBB_DAQ_T SystemID_BBB_DAQ_ConstP;

/* Model entry point functions */
extern void SystemID_BBB_DAQ_initialize(void);
extern void SystemID_BBB_DAQ_step(void);
extern void SystemID_BBB_DAQ_terminate(void);

/* Real-time Model object */
extern RT_MODEL_SystemID_BBB_DAQ_T *const SystemID_BBB_DAQ_M;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'SystemID_BBB_DAQ'
 */
#endif                                 /* RTW_HEADER_SystemID_BBB_DAQ_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
