PRO HIIHAT_TEST
	
	inFilePath = 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok.dat'
	fileStretch = 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str.img'

Ahx_Stretch_doit, 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok.dat', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str.img', 1, 0, 100, 0, 0, 1000, 4
hiihat_preprocess_doit, 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str.img', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp.img', 2, 'Euclidean (L 2)', 'None',0,1,'Generic'
hiihat_segment_doit, 0.01, 20, 'euclidean_sq', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str.img', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_seg.img'
hiihat_get_superpixel_endmembers_doit, 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp.img', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp_seg.img', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp_endm.sli', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp_endm.roi', 10, 0, 'SMACC'
hiihat_class_doit, 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp.img', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp.sli', 'SAM', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_class.img', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp_rule.img'

END

hiihat_segment_doit, 0.01, 20, 'euclidean_sq', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp.img', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp_seg.img'
