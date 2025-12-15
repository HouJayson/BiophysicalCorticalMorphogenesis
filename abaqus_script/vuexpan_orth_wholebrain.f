C------------------------------------------------------------------
C "Subroutines used to define all regional growth models"
C
C
      subroutine vuexpan (
C Read only (unmodifiable)variables -
     * nblock, nDir, nShr, nExpanType,
     * nElem, nIntPt, nLayer, nSectPt,
     * stepTime, totalTime, dt, cmname, 
     * nstatev, nfieldv, nprops, props,
     * tempOld, tempNew, fieldOld, fieldNew,
     * stateOld, 
C Write only (modifiable) variable -
     * stateNew, strainThInc, dStrainTherDT )
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * nElem(nblock), props(nprops),
     * tempOld(nblock), tempNew(nblock),
     * fieldOld(nblock,nfieldv),
     * fieldNew(nblock,nfieldv),
     * stateOld(nblock,nstatev),
     * stateNew(nblock,nstatev)
C
C
      character*80 cmname
C 
      if (cmname(1:14) .eq. 'GRAY_REGION_00') then
         call vuexpan_region_00(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
      else if (cmname(1:14) .eq. 'GRAY_REGION_01') then
         call vuexpan_region_01(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)       
      else if (cmname(1:14) .eq. 'GRAY_REGION_02') then
         call vuexpan_region_02(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)           
      else if (cmname(1:14) .eq. 'GRAY_REGION_03') then
         call vuexpan_region_03(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)      
      else if (cmname(1:14) .eq. 'GRAY_REGION_04') then
         call vuexpan_region_04(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)          
      else if (cmname(1:14) .eq. 'GRAY_REGION_05') then
         call vuexpan_region_05(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)      
      else if (cmname(1:14) .eq. 'GRAY_REGION_06') then
         call vuexpan_region_06(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)            
      else if (cmname(1:14) .eq. 'GRAY_REGION_07') then
         call vuexpan_region_07(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)           
      else if (cmname(1:14) .eq. 'GRAY_REGION_08') then
         call vuexpan_region_08(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)     
      else if (cmname(1:14) .eq. 'GRAY_REGION_09') then
         call vuexpan_region_09(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)           
      else if (cmname(1:14) .eq. 'GRAY_REGION_10') then
         call vuexpan_region_10(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)                         
      else if (cmname(1:14) .eq. 'GRAY_REGION_11') then
         call vuexpan_region_11(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)       
      else if (cmname(1:14) .eq. 'GRAY_REGION_12') then
         call vuexpan_region_12(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)        
      else if (cmname(1:14) .eq. 'GRAY_REGION_13') then
         call vuexpan_region_13(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)        
      else if (cmname(1:14) .eq. 'GRAY_REGION_14') then
         call vuexpan_region_14(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)         
      else if (cmname(1:14) .eq. 'GRAY_REGION_15') then
         call vuexpan_region_15(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)       
      else if (cmname(1:14) .eq. 'GRAY_REGION_16') then
         call vuexpan_region_16(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)       
      else if (cmname(1:14) .eq. 'GRAY_REGION_17') then
         call vuexpan_region_17(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)       
      else if (cmname(1:14) .eq. 'GRAY_REGION_18') then
         call vuexpan_region_18(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
      else if (cmname(1:14) .eq. 'GRAY_REGION_19') then
         call vuexpan_region_00(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)        
      else if (cmname(1:14) .eq. 'GRAY_REGION_20') then
         call vuexpan_region_20(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)           
      else if (cmname(1:14) .eq. 'GRAY_REGION_21') then
         call vuexpan_region_21(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)      
      else if (cmname(1:14) .eq. 'GRAY_REGION_22') then
         call vuexpan_region_22(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)          
      else if (cmname(1:14) .eq. 'GRAY_REGION_23') then
         call vuexpan_region_23(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)      
      else if (cmname(1:14) .eq. 'GRAY_REGION_24') then
         call vuexpan_region_24(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)            
      else if (cmname(1:14) .eq. 'GRAY_REGION_25') then
         call vuexpan_region_25(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)           
      else if (cmname(1:14) .eq. 'GRAY_REGION_26') then
         call vuexpan_region_26(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)     
      else if (cmname(1:14) .eq. 'GRAY_REGION_27') then
         call vuexpan_region_27(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)           
      else if (cmname(1:14) .eq. 'GRAY_REGION_28') then
         call vuexpan_region_28(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)                         
      else if (cmname(1:14) .eq. 'GRAY_REGION_29') then
         call vuexpan_region_29(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)       
      else if (cmname(1:14) .eq. 'GRAY_REGION_30') then
         call vuexpan_region_30(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)        
      else if (cmname(1:14) .eq. 'GRAY_REGION_31') then
         call vuexpan_region_31(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)        
      else if (cmname(1:14) .eq. 'GRAY_REGION_32') then
         call vuexpan_region_32(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)         
      else if (cmname(1:14) .eq. 'GRAY_REGION_33') then
         call vuexpan_region_33(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)       
      else if (cmname(1:14) .eq. 'GRAY_REGION_34') then
         call vuexpan_region_34(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)       
      else if (cmname(1:14) .eq. 'GRAY_REGION_35') then
         call vuexpan_region_35(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)       
      else if (cmname(1:14) .eq. 'GRAY_REGION_36') then
         call vuexpan_region_36(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)   
      else if (cmname(1:14) .eq. 'GRAY_REGION_37') then
         call vuexpan_region_37(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT) 
      else if (cmname(1:5) .eq. 'WHITE') then
         call vuexpan_region_white(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)            
      else
         call xplb_abqerr(-2,'User subroutine VUEXPAN missing!',intv,zero,' ')
         call xplb_exit               
      end if
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_00(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)   
C
      logical, save :: PrintStatus1 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus1) then
          print *, "User subroutine vuexpan_region_00 is being used."
          PrintStatus1 = .true.
      endif       
C            
      nExpanType=2
C
      alpha1 = 0.41
      alpha2 = 0.41
      alpha3 = 0.0
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end      
c------------------------------------------------------------------
      subroutine vuexpan_region_01(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)   
C
      logical, save :: PrintStatus1 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus1) then
          print *, "User subroutine vuexpan_region_01 is being used."
          PrintStatus1 = .true.
      endif       
C            
      nExpanType=2
C
      alpha1 = 1.46
      alpha2 = 1.46
      alpha3 = 0.13
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_02(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)   
C
      logical, save :: PrintStatus1 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus1) then
          print *, "User subroutine vuexpan_region_01 is being used."
          PrintStatus1 = .true.
      endif       
C            
      nExpanType=2
C
      alpha1 = 1.62
      alpha2 = 1.62
      alpha3 = 0.08
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_03(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)   
C
      logical, save :: PrintStatus1 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus1) then
          print *, "User subroutine vuexpan_region_01 is being used."
          PrintStatus1 = .true.
      endif       
C            
      nExpanType=2
C
      alpha1 = 1.58
      alpha2 = 1.58
      alpha3 = 0.11
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end            
c------------------------------------------------------------------
      subroutine vuexpan_region_04(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus4 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus4) then
          print *, "User subroutine vuexpan_region_04 is being used."
          PrintStatus4 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.51
      alpha2 = 1.51 
      alpha3 = -0.19 *2* totalTime + 0.20
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_05(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus4 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus4) then
          print *, "User subroutine vuexpan_region_04 is being used."
          PrintStatus4 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.83
      alpha2 = 1.83
      alpha3 = -0.31*2* totalTime + 0.38
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_06(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus4 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus4) then
          print *, "User subroutine vuexpan_region_04 is being used."
          PrintStatus4 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.48
      alpha2 = 1.48
      alpha3 = -0.18 *2* totalTime + 0.24
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_07(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus4 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus4) then
          print *, "User subroutine vuexpan_region_04 is being used."
          PrintStatus4 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.67 
      alpha2 = 1.67
      alpha3 = 0.12
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_08(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus4 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus4) then
          print *, "User subroutine vuexpan_region_04 is being used."
          PrintStatus4 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.60
      alpha2 = 1.60
      alpha3 = -0.23 *2* totalTime + 0.28
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end      
c------------------------------------------------------------------
      subroutine vuexpan_region_09(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus9 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus9) then
          print *, "User subroutine vuexpan_region_09 is being used."
          PrintStatus9 = .true.
      endif 
C  
      nExpanType=2
C
      alpha1 = 1.80
      alpha2 = 1.80
      alpha3 = -0.13 *2* totalTime + 0.12
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_10(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus9 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus9) then
          print *, "User subroutine vuexpan_region_09 is being used."
          PrintStatus9 = .true.
      endif 
C  
      nExpanType=2
C
      alpha1 = 1.23
      alpha2 = 1.23 
      alpha3 = -0.09 *2* totalTime + 0.1
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_11(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus11 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus11) then
          print *, "User subroutine vuexpan_region_11 is being used."
          PrintStatus11 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.44
      alpha2 = 1.44
      alpha3 = -0.12 *2 *totalTime + 0.14
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_12(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus11 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus11) then
          print *, "User subroutine vuexpan_region_11 is being used."
          PrintStatus11 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.86
      alpha2 = 1.86
      alpha3 = -0.29 *2* totalTime + 0.37
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_13(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus11 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus11) then
          print *, "User subroutine vuexpan_region_11 is being used."
          PrintStatus11 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.29
      alpha2 = 1.29
      alpha3 = -0.17*2 *totalTime + 0.21
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_14(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus11 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus11) then
          print *, "User subroutine vuexpan_region_11 is being used."
          PrintStatus11 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.73
      alpha1 = 1.73
      alpha3 = -0.24 *2 *totalTime + 0.27
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_15(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus11 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus11) then
          print *, "User subroutine vuexpan_region_11 is being used."
          PrintStatus11 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.39 
      alpha2 = 1.39 
      alpha3 = 0.16 
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_16(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus16 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus16) then
          print *, "User subroutine vuexpan_region_16 is being used."
          PrintStatus16 = .true.
      endif 
C
      nExpanType=2
C
      alpha1 = 1.53 
      alpha2 = 1.53
      alpha3 = -0.11 *2 *totalTime + 0.15
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_17(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus16 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus16) then
          print *, "User subroutine vuexpan_region_16 is being used."
          PrintStatus16 = .true.
      endif 
C
      nExpanType=2
C
      alpha1 = 1.77 
      alpha2 = 1.77 
      alpha3 = -0.2 *2* totalTime + 0.25
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_18(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus16 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus16) then
          print *, "User subroutine vuexpan_region_16 is being used."
          PrintStatus16 = .true.
      endif 
C
      nExpanType=2
C
      alpha1 = 1.56
      alpha2 = 1.56
      alpha3 = -0.32 *2 *totalTime + 0.34
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_20(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)   
C
      logical, save :: PrintStatus1 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus1) then
          print *, "User subroutine vuexpan_region_01 is being used."
          PrintStatus1 = .true.
      endif       
C            
      nExpanType=2
C
      alpha1 = 1.44 
      alpha2 = 1.44 
      alpha3 = 0.18 
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_21(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)   
C
      logical, save :: PrintStatus1 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus1) then
          print *, "User subroutine vuexpan_region_01 is being used."
          PrintStatus1 = .true.
      endif       
C            
      nExpanType=2
C
      alpha1 = 1.56 
      alpha2 = 1.56 
      alpha3 = 0.06
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_22(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)   
C
      logical, save :: PrintStatus1 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus1) then
          print *, "User subroutine vuexpan_region_01 is being used."
          PrintStatus1 = .true.
      endif       
C            
      nExpanType=2
C
      alpha1 = 1.62
      alpha2 = 1.62
      alpha3 = 0.17
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end            
c------------------------------------------------------------------
      subroutine vuexpan_region_23(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus4 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus4) then
          print *, "User subroutine vuexpan_region_04 is being used."
          PrintStatus4 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.57
      alpha2 = 1.57
      alpha3 = 0.08
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_24(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus4 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus4) then
          print *, "User subroutine vuexpan_region_04 is being used."
          PrintStatus4 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.69
      alpha2 = 1.69
      alpha3 = -0.32* 2 *totalTime + 0.43
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_25(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus4 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus4) then
          print *, "User subroutine vuexpan_region_04 is being used."
          PrintStatus4 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.42
      alpha2 = 1.42
      alpha3 = 0.09
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_26(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus4 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus4) then
          print *, "User subroutine vuexpan_region_04 is being used."
          PrintStatus4 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.71 
      alpha2 = 1.71 
      alpha3 = 0.19 
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_27(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus4 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus4) then
          print *, "User subroutine vuexpan_region_04 is being used."
          PrintStatus4 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.49 
      alpha2 = 1.49 
      alpha3 = 0.07
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end      
c------------------------------------------------------------------
      subroutine vuexpan_region_28(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus9 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus9) then
          print *, "User subroutine vuexpan_region_09 is being used."
          PrintStatus9 = .true.
      endif 
C  
      nExpanType=2
C
      alpha1 = 1.6
      alpha2 = 1.6
      alpha3 = 0.12 
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_29(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus9 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus9) then
          print *, "User subroutine vuexpan_region_09 is being used."
          PrintStatus9 = .true.
      endif 
C  
      nExpanType=2
C
      alpha1 = 1.48 
      alpha2 = 1.48 
      alpha3 = -0.22 *2* totalTime + 0.32
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_30(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus11 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus11) then
          print *, "User subroutine vuexpan_region_11 is being used."
          PrintStatus11 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.37 
      alpha2 = 1.37 
      alpha3 = 0.1 
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_31(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus11 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus11) then
          print *, "User subroutine vuexpan_region_11 is being used."
          PrintStatus11 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.73
      alpha2 = 1.73 
      alpha3 = -0.27*2*totalTime + 0.34
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_32(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus11 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus11) then
          print *, "User subroutine vuexpan_region_11 is being used."
          PrintStatus11 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.22 
      alpha2 = 1.22 
      alpha3 = 0.13 
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_33(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus11 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus11) then
          print *, "User subroutine vuexpan_region_11 is being used."
          PrintStatus11 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.79 
      alpha2 = 1.79 
      alpha3 = 0.14 
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_34(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus11 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus11) then
          print *, "User subroutine vuexpan_region_11 is being used."
          PrintStatus11 = .true.
      endif 
C      
      nExpanType=2
C
      alpha1 = 1.45 
      alpha2 = 1.45 
      alpha3 = 0.16 
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_35(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus16 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus16) then
          print *, "User subroutine vuexpan_region_16 is being used."
          PrintStatus16 = .true.
      endif 
C
      nExpanType=2
C
      alpha1 = 1.59 
      alpha2 = 1.59
      alpha3 = 0.11 
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_36(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus16 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus16) then
          print *, "User subroutine vuexpan_region_16 is being used."
          PrintStatus16 = .true.
      endif 
C
      nExpanType=2
C
      alpha1 = 1.87 
      alpha2 = 1.87 
      alpha3 = -0.41*2*totalTime + 0.48
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_37(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus16 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus16) then
          print *, "User subroutine vuexpan_region_16 is being used."
          PrintStatus16 = .true.
      endif 
C
      nExpanType=2
C
      alpha1 = 1.54
      alpha2 = 1.54
      alpha3 = -0.31*2*totalTime + 0.33
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha1*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha2*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha3*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end
c------------------------------------------------------------------
      subroutine vuexpan_region_white(nblock, nDir, nShr, nExpanType,stepTime, totalTime, dt, 
     *       tempOld, tempNew, strainThInc, dStrainTherDT)
C
      include 'vaba_param.inc'
C
      dimension strainThInc(nblock,nDir+nShr),
     * dStrainTherDT(nblock,nDir+nShr),
     * tempOld(nblock), tempNew(nblock)
C
      logical, save :: PrintStatus16 = .false.  ! Declare the flag variable as static
      if (.not. PrintStatus16) then
          print *, "User subroutine vuexpan_region_IC is being used."
          PrintStatus16 = .true.
      endif 
C
      nExpanType=1
C
      alpha = 0.41/0.091
C
      do 100 km = 1, nblock
        strainThInc(km, 1)=alpha*(tempNew(km)-tempOld(km))
        strainThInc(km, 2)=alpha*(tempNew(km)-tempOld(km))
        strainThInc(km, 3)=alpha*(tempNew(km)-tempOld(km))        
 100  continue
C
      return
      end      