#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''Script to do tissue segmentation on 9.4T images with FSL's fast.

Steps:
    1. Extract object(brain) mask.
    2. Apply mask to the image.
    3. Do segmentation

Author: YingLi Lu, yinglilu@gmail.com
Date: 2017-06-28

note: 
    1. need c3d,fsl installed.
    2. path structure(according to Ali's scripts):
        #path:    data_dir/subject_id/session/specimen_name
        #example: epilepsyPhase1/Ex/EPI_P006/{9.4T,Pre_fix,Post_fix}/{Combined,Hp,Neo}

        #filename:MRI_PreExReg.nii.gz
    3. need ~2 hours on a i7-4xxx CPU. Add '--nobias' option can be 10 time faster, but less accurate.
'''

import os
import sys
import tempfile
import subprocess

DEBUG=False
if DEBUG:
    FAST = 'fsl5.0-fast -v' #name might different with different versions/OS system.
else:
    FAST = 'fsl5.0-fast'

INPUT_FILENAME='MRI_PreExReg.nii.gz'

TEMP_DIR=tempfile.gettempdir() #some intermediate files will output to temp directory.

def extract_brain(FAST,input_fullfilename,output_fullfilename,image_type=2,H=0.1):
    '''
    extract brain mask
    
    input:
        brain image

    ouput：
        mask image(1-brain,0-background), will output to /tmp

    steps:
        1. two class FSL's fast segmentation
        2. binary threshold.
        3. extract largest connected component.
    '''

    import tempfile

    TEMP_DIR=tempfile.gettempdir() #some intermediate files will output to temp directory.

    #step.1
    seg_result_prefix=os.path.join(TEMP_DIR,'temp') #fast output will be: temp_seg.nii.gz ('_seg' builtin fast)
    cmd_fast_seg = '{} -n 2 -t {}  -H {} --nopve -o {} {}'.format(FAST,image_type,H,seg_result_prefix,input_fullfilename)
    os.system(cmd_fast_seg)
    seg_result_fullname=seg_result_prefix+'_seg.nii.gz'

    #step.2
    binary_mask_result_fullname = os.path.join(TEMP_DIR,'temp_mask.nii')
    cmd_binary_mask = 'c3d {} -thresh 1 1 1 0 -type uchar -o {} > /dev/null'.format(seg_result_fullname,binary_mask_result_fullname) 
    os.system(cmd_binary_mask)

    #step.3
    cmd_largest_connected_component = 'c3d {} -comp -threshold 1 1 1 0 -type uchar -o {} > /dev/null'.format(binary_mask_result_fullname,output_fullfilename)
    os.system(cmd_largest_connected_component)

    
def fast_segmentation(FAST,input_fullfilename,mask_fullfilename,output_fullprefix,class_num,image_type=2,H=0.1):
    '''
    FSL's fast tissues segmenation
    
    input:
        brain image
        brain mask image(1-object,0-background)
        class_num: number of tissue types, normally 3. If use a number >3, need combine classes manually.
        image_type: 1 for T1, 2 for T2, 3 for PD, default:2
        H: increasing this gives spatially smoother segmentations, default:0.1. note: for 9.4T image, 0.1 is good, 0.2-0.3 is too high(smooth)

    ouput：
        segmentation: 'input_fullfilename'_seg.nii.gz, (same directory of input)

    Steps:
        1. Apply mask to the image.
        2. Do segmentation
    '''

    #step.1
    import tempfile
    TEMP_DIR=tempfile.gettempdir() #some intermediate files will output to temp directory.

    apply_mask_result_fullname=os.path.join(TEMP_DIR,'temp_masked.nii')
    cmd_apply_mask = 'c3d {} {} -multiply -o {} > /dev/null'.format(input_fullfilename,mask_fullfilename,apply_mask_result_fullname)
    os.system(cmd_apply_mask)

    #setp.2
    cmd_fast_seg = '{} -n {} -t {} -H {} --nopve -o {} {}'.format(FAST,class_num,image_type,H,output_fullprefix,apply_mask_result_fullname)
    os.system(cmd_fast_seg)

    
if __name__ == '__main__':
    if len(sys.argv) < 5:
        print ("usage: ./2.0_segmentTissueFast9.4T.py <ex_data_dir> <subject_ID> <session(9.4T,Pre_fix,Post_fix)> <specimen_name (Combined,Hp,Neo)> <classes_number(2,3,...)>")
        print ("example: ./2.0_segmentTissueFast9.4T.py ~/EpilepsyDatabase/epilepsyPhase1/Ex EPI_P031 9.4T Neo 3")
        sys.exit()

    class_num = sys.argv[5]
    input_fullfilename = os.path.join(sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4],INPUT_FILENAME)
    
    print 'Processing: ', input_fullfilename

    #extract brain
    print '  extract brain...',
    sys.stdout.flush()
    mask_fullfilename = os.path.join(TEMP_DIR,'temp_brain_mask.nii')
    extract_brain(FAST,input_fullfilename,mask_fullfilename)
    print '  done'
    sys.stdout.flush()

    #fast segmentation.
    print '  fast segmentation...',
    sys.stdout.flush()
    output_fullprefix = input_fullfilename[:-7]+'_'+str(class_num) #remove '.nii.gz', the segmentation result is 'output_fullprefix_classnumber_seg.nii.gz'
    fast_segmentation(FAST,input_fullfilename,mask_fullfilename,output_fullprefix,class_num)
    print '  done'
    sys.stdout.flush()

    output_fullfilename=output_fullprefix+'_seg_'+class_num+'.nii.gz'
    print '  result: ',output_fullfilename
    
