Ahx_Mosaic_Doit, ['D:\\HyperSpecture\\HyData\\6-图像镶嵌\\mosaic1.img', 'D:\\HyperSpecture\\HyData\\6-图像镶嵌\\mosaic2.img'], 'D:\\HyperSpecture\\HyData\\6-图像镶嵌\\all.img'

Ahx_Mosaic_Doit, ['D:\\HyperSpecture\\HyData\\6-图像镶嵌\\mosaic1.img', 'D:\\HyperSpecture\\HyData\\6-图像镶嵌\\mosaic2.img', ], 'D:\\HyperSpecture\\HyData\\6-图像镶嵌\\all3.img',background=,use_see_through = [1L, 1L, ],see_through_val = [255, 255, ]

Ahx_SHARPEN_DOIT, 'D:\\HyperSpecture\\HyData\\5-图像融合\\qb_boulder_pan.img', 'D:\\HyperSpecture\\HyData\\5-图像融合\\qb_boulder_msi.img', 'D:\\HyperSpecture\\HyData\\5-图像融合\\F1', 0


Ahx_Ras_Export.pro,'D:\\HyperSpecture\\HyData\\8-Convert\\can_tmr.img','D:\\HyperSpecture\\HyData\\8-Convert\\can_tmr2.tif','TIFF','bip'

Ahx_Stretch_doit, 'D:\\HyperSpecture\\Urban\\Land', 'D:\\HyperSpecture\\Land\\land_str.img', 1, 0, 100, 0, 0, 1000, 4


Ahx_Stretch_doit, 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok.dat', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str.img', 1, 0, 100, 0, 0, 1000, 4
hiihat_preprocess_doit, 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str.img', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp.img', 2, 'Euclidean (L 2)', 'None',0,1,'Generic'
hiihat_segment_doit, 0.01, 20, 'euclidean_sq', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str.img', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_seg.img'
hiihat_get_superpixel_endmembers_doit, 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp.img', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp_seg.img', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp_endm.sli', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp_endm.roi', 10, 0, 'SMACC'
hiihat_class_doit, 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp.img', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp.sli', 'SAM', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_class.img', 'F:\\HyperSpecture\\Hb_20180429old\\All\\20180429_4-5Envi-ok_str_pp_rule.img'
  
hiihat_preprocess_doit, 'F:\\HyperSpecture\\Land\\land_str.img', 'F:\\HyperSpecture\\Land\\land_str_pp.img', 2, 'Euclidean (L 2)', 'None',0,1,'Generic'
hiihat_preprocess_doit, 'F:\HyperSpecture\Hb_20180429old\Corn\Corn_str.img', 'F:\HyperSpecture\Hb_20180429old\Corn\Corn_str_pp.img', 2, 'Euclidean (L 2)', 'None',0,1,'Generic'
hiihat_preprocess_doit, 'F:\\HyperSpecture\\Hb_20180429old\\Corn\\Corn_str.img', 'F:\\HyperSpecture\\Hb_20180429old\\Corn\\Corn_str_pp.img', 2, 'Euclidean (L 2)', 'Spatial Mean',2,1,'Generic'
