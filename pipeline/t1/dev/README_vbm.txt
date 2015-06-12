
Steps in FSL VBM:

	prepare data
		-copy images to folder, sorted by group (prefix in filename)

	fslvbm_1_bet
		-takes in all T1 images
		-skull-strips
		-writes to:  struc/*_brain.nii.gz

	fslvbm_2_template
		-builds symmetric GM template
		-1. tissue segmentation 
		-2. aff register GM to GM ICBM152
		-3. average, flip and average
		-4. non-linear register GM to template from 3.
		-5. average, flip and average (final space is 2x2x2mm --- is reg done in 2mm space too?)
		
		-guidelines: same # of patients/controls to build template; can choose between affine or non-linear reg


	fslvbm_3_proc

		-register all subject GM to the template
		-concatenate (GM_merg)
		-or, modulate by jacobian then concatenate (GM_mod_merg)
		-smooth (sigma 2,3,4 mm)
		-run stats using mask and randomise


		
	---- if VBM/TBM is to be used, need to:
		1) add a step after fslvbm_2_template to 
		 generate registration confidence map (using warped GM segs -- can symmetrize afterwards)
		
		2) provide alternate fslvbm_3_proc command (fslvbm_3_uvtbmproc) that 
		 modulates according to reg confidence map

		
		


#test data:

	Unilateral MTS (path confirmed) vs Ctrls


		

