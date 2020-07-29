/*************************/
/* Lectura de las tablas */
/*************************/

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      06JUN20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.UNDEREXPOSE_USER_FEAT    ;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path./data/underexpose_train/underexpose_user_feat.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
   informat VAR1 best32. ;
   informat VAR2 best32. ;
   informat VAR3 $1. ;
   informat VAR4 best32. ;
   format VAR1 best12. ;
   format VAR2 best12. ;
   format VAR3 $1. ;
   format VAR4 best12. ;
input
            VAR1
            VAR2
            VAR3 $
            VAR4
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

data kdd2020.UNDEREXPOSE_USER_FEAT    ;
  set kdd2020.UNDEREXPOSE_USER_FEAT    ;
  rename VAR1=USER_ID
  VAR2=user_age_level
  VAR3=user_gender
  VAR4=user_city_level;
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      12JUN20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data WORK.item_features;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path./user_data/underexpose_item_feat_fix.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
   informat VAR1 best32. ;
   informat VAR2 best32. ;
   informat VAR3 best32. ;
   informat VAR4 best32. ;
   informat VAR5 best32. ;
   informat VAR6 best32. ;
   informat VAR7 best32. ;
   informat VAR8 best32. ;
   informat VAR9 best32. ;
   informat VAR10 best32. ;
   informat VAR11 best32. ;
   informat VAR12 best32. ;
   informat VAR13 best32. ;
   informat VAR14 best32. ;
   informat VAR15 best32. ;
   informat VAR16 best32. ;
   informat VAR17 best32. ;
   informat VAR18 best32. ;
   informat VAR19 best32. ;
   informat VAR20 best32. ;
   informat VAR21 best32. ;
   informat VAR22 best32. ;
   informat VAR23 best32. ;
   informat VAR24 best32. ;
   informat VAR25 best32. ;
   informat VAR26 best32. ;
   informat VAR27 best32. ;
   informat VAR28 best32. ;
   informat VAR29 best32. ;
   informat VAR30 best32. ;
   informat VAR31 best32. ;
   informat VAR32 best32. ;
   informat VAR33 best32. ;
   informat VAR34 best32. ;
   informat VAR35 best32. ;
   informat VAR36 best32. ;
   informat VAR37 best32. ;
   informat VAR38 best32. ;
   informat VAR39 best32. ;
   informat VAR40 best32. ;
   informat VAR41 best32. ;
   informat VAR42 best32. ;
   informat VAR43 best32. ;
   informat VAR44 best32. ;
   informat VAR45 best32. ;
   informat VAR46 best32. ;
   informat VAR47 best32. ;
   informat VAR48 best32. ;
   informat VAR49 best32. ;
   informat VAR50 best32. ;
   informat VAR51 best32. ;
   informat VAR52 best32. ;
   informat VAR53 best32. ;
   informat VAR54 best32. ;
   informat VAR55 best32. ;
   informat VAR56 best32. ;
   informat VAR57 best32. ;
   informat VAR58 best32. ;
   informat VAR59 best32. ;
   informat VAR60 best32. ;
   informat VAR61 best32. ;
   informat VAR62 best32. ;
   informat VAR63 best32. ;
   informat VAR64 best32. ;
   informat VAR65 best32. ;
   informat VAR66 best32. ;
   informat VAR67 best32. ;
   informat VAR68 best32. ;
   informat VAR69 best32. ;
   informat VAR70 best32. ;
   informat VAR71 best32. ;
   informat VAR72 best32. ;
   informat VAR73 best32. ;
   informat VAR74 best32. ;
   informat VAR75 best32. ;
   informat VAR76 best32. ;
   informat VAR77 best32. ;
   informat VAR78 best32. ;
   informat VAR79 best32. ;
   informat VAR80 best32. ;
   informat VAR81 best32. ;
   informat VAR82 best32. ;
   informat VAR83 best32. ;
   informat VAR84 best32. ;
   informat VAR85 best32. ;
   informat VAR86 best32. ;
   informat VAR87 best32. ;
   informat VAR88 best32. ;
   informat VAR89 best32. ;
   informat VAR90 best32. ;
   informat VAR91 best32. ;
   informat VAR92 best32. ;
   informat VAR93 best32. ;
   informat VAR94 best32. ;
   informat VAR95 best32. ;
   informat VAR96 best32. ;
   informat VAR97 best32. ;
   informat VAR98 best32. ;
   informat VAR99 best32. ;
   informat VAR100 best32. ;
   informat VAR101 best32. ;
   informat VAR102 best32. ;
   informat VAR103 best32. ;
   informat VAR104 best32. ;
   informat VAR105 best32. ;
   informat VAR106 best32. ;
   informat VAR107 best32. ;
   informat VAR108 best32. ;
   informat VAR109 best32. ;
   informat VAR110 best32. ;
   informat VAR111 best32. ;
   informat VAR112 best32. ;
   informat VAR113 best32. ;
   informat VAR114 best32. ;
   informat VAR115 best32. ;
   informat VAR116 best32. ;
   informat VAR117 best32. ;
   informat VAR118 best32. ;
   informat VAR119 best32. ;
   informat VAR120 best32. ;
   informat VAR121 best32. ;
   informat VAR122 best32. ;
   informat VAR123 best32. ;
   informat VAR124 best32. ;
   informat VAR125 best32. ;
   informat VAR126 best32. ;
   informat VAR127 best32. ;
   informat VAR128 best32. ;
   informat VAR129 best32. ;
   informat VAR130 best32. ;
   informat VAR131 best32. ;
   informat VAR132 best32. ;
   informat VAR133 best32. ;
   informat VAR134 best32. ;
   informat VAR135 best32. ;
   informat VAR136 best32. ;
   informat VAR137 best32. ;
   informat VAR138 best32. ;
   informat VAR139 best32. ;
   informat VAR140 best32. ;
   informat VAR141 best32. ;
   informat VAR142 best32. ;
   informat VAR143 best32. ;
   informat VAR144 best32. ;
   informat VAR145 best32. ;
   informat VAR146 best32. ;
   informat VAR147 best32. ;
   informat VAR148 best32. ;
   informat VAR149 best32. ;
   informat VAR150 best32. ;
   informat VAR151 best32. ;
   informat VAR152 best32. ;
   informat VAR153 best32. ;
   informat VAR154 best32. ;
   informat VAR155 best32. ;
   informat VAR156 best32. ;
   informat VAR157 best32. ;
   informat VAR158 best32. ;
   informat VAR159 best32. ;
   informat VAR160 best32. ;
   informat VAR161 best32. ;
   informat VAR162 best32. ;
   informat VAR163 best32. ;
   informat VAR164 best32. ;
   informat VAR165 best32. ;
   informat VAR166 best32. ;
   informat VAR167 best32. ;
   informat VAR168 best32. ;
   informat VAR169 best32. ;
   informat VAR170 best32. ;
   informat VAR171 best32. ;
   informat VAR172 best32. ;
   informat VAR173 best32. ;
   informat VAR174 best32. ;
   informat VAR175 best32. ;
   informat VAR176 best32. ;
   informat VAR177 best32. ;
   informat VAR178 best32. ;
   informat VAR179 best32. ;
   informat VAR180 best32. ;
   informat VAR181 best32. ;
   informat VAR182 best32. ;
   informat VAR183 best32. ;
   informat VAR184 best32. ;
   informat VAR185 best32. ;
   informat VAR186 best32. ;
   informat VAR187 best32. ;
   informat VAR188 best32. ;
   informat VAR189 best32. ;
   informat VAR190 best32. ;
   informat VAR191 best32. ;
   informat VAR192 best32. ;
   informat VAR193 best32. ;
   informat VAR194 best32. ;
   informat VAR195 best32. ;
   informat VAR196 best32. ;
   informat VAR197 best32. ;
   informat VAR198 best32. ;
   informat VAR199 best32. ;
   informat VAR200 best32. ;
   informat VAR201 best32. ;
   informat VAR202 best32. ;
   informat VAR203 best32. ;
   informat VAR204 best32. ;
   informat VAR205 best32. ;
   informat VAR206 best32. ;
   informat VAR207 best32. ;
   informat VAR208 best32. ;
   informat VAR209 best32. ;
   informat VAR210 best32. ;
   informat VAR211 best32. ;
   informat VAR212 best32. ;
   informat VAR213 best32. ;
   informat VAR214 best32. ;
   informat VAR215 best32. ;
   informat VAR216 best32. ;
   informat VAR217 best32. ;
   informat VAR218 best32. ;
   informat VAR219 best32. ;
   informat VAR220 best32. ;
   informat VAR221 best32. ;
   informat VAR222 best32. ;
   informat VAR223 best32. ;
   informat VAR224 best32. ;
   informat VAR225 best32. ;
   informat VAR226 best32. ;
   informat VAR227 best32. ;
   informat VAR228 best32. ;
   informat VAR229 best32. ;
   informat VAR230 best32. ;
   informat VAR231 best32. ;
   informat VAR232 best32. ;
   informat VAR233 best32. ;
   informat VAR234 best32. ;
   informat VAR235 best32. ;
   informat VAR236 best32. ;
   informat VAR237 best32. ;
   informat VAR238 best32. ;
   informat VAR239 best32. ;
   informat VAR240 best32. ;
   informat VAR241 best32. ;
   informat VAR242 best32. ;
   informat VAR243 best32. ;
   informat VAR244 best32. ;
   informat VAR245 best32. ;
   informat VAR246 best32. ;
   informat VAR247 best32. ;
   informat VAR248 best32. ;
   informat VAR249 best32. ;
   informat VAR250 best32. ;
   informat VAR251 best32. ;
   informat VAR252 best32. ;
   informat VAR253 best32. ;
   informat VAR254 best32. ;
   informat VAR255 best32. ;
   informat VAR256 best32. ;
   informat VAR257 best32. ;
   format VAR1 best12. ;
   format VAR2 best12. ;
   format VAR3 best12. ;
   format VAR4 best12. ;
   format VAR5 best12. ;
   format VAR6 best12. ;
   format VAR7 best12. ;
   format VAR8 best12. ;
   format VAR9 best12. ;
   format VAR10 best12. ;
   format VAR11 best12. ;
   format VAR12 best12. ;
   format VAR13 best12. ;
   format VAR14 best12. ;
   format VAR15 best12. ;
   format VAR16 best12. ;
   format VAR17 best12. ;
   format VAR18 best12. ;
   format VAR19 best12. ;
   format VAR20 best12. ;
   format VAR21 best12. ;
   format VAR22 best12. ;
   format VAR23 best12. ;
   format VAR24 best12. ;
   format VAR25 best12. ;
   format VAR26 best12. ;
   format VAR27 best12. ;
   format VAR28 best12. ;
   format VAR29 best12. ;
   format VAR30 best12. ;
   format VAR31 best12. ;
   format VAR32 best12. ;
   format VAR33 best12. ;
   format VAR34 best12. ;
   format VAR35 best12. ;
   format VAR36 best12. ;
   format VAR37 best12. ;
   format VAR38 best12. ;
   format VAR39 best12. ;
   format VAR40 best12. ;
   format VAR41 best12. ;
   format VAR42 best12. ;
   format VAR43 best12. ;
   format VAR44 best12. ;
   format VAR45 best12. ;
   format VAR46 best12. ;
   format VAR47 best12. ;
   format VAR48 best12. ;
   format VAR49 best12. ;
   format VAR50 best12. ;
   format VAR51 best12. ;
   format VAR52 best12. ;
   format VAR53 best12. ;
   format VAR54 best12. ;
   format VAR55 best12. ;
   format VAR56 best12. ;
   format VAR57 best12. ;
   format VAR58 best12. ;
   format VAR59 best12. ;
   format VAR60 best12. ;
   format VAR61 best12. ;
   format VAR62 best12. ;
   format VAR63 best12. ;
   format VAR64 best12. ;
   format VAR65 best12. ;
   format VAR66 best12. ;
   format VAR67 best12. ;
   format VAR68 best12. ;
   format VAR69 best12. ;
   format VAR70 best12. ;
   format VAR71 best12. ;
   format VAR72 best12. ;
   format VAR73 best12. ;
   format VAR74 best12. ;
   format VAR75 best12. ;
   format VAR76 best12. ;
   format VAR77 best12. ;
   format VAR78 best12. ;
   format VAR79 best12. ;
   format VAR80 best12. ;
   format VAR81 best12. ;
   format VAR82 best12. ;
   format VAR83 best12. ;
   format VAR84 best12. ;
   format VAR85 best12. ;
   format VAR86 best12. ;
   format VAR87 best12. ;
   format VAR88 best12. ;
   format VAR89 best12. ;
   format VAR90 best12. ;
   format VAR91 best12. ;
   format VAR92 best12. ;
   format VAR93 best12. ;
   format VAR94 best12. ;
   format VAR95 best12. ;
   format VAR96 best12. ;
   format VAR97 best12. ;
   format VAR98 best12. ;
   format VAR99 best12. ;
   format VAR100 best12. ;
   format VAR101 best12. ;
   format VAR102 best12. ;
   format VAR103 best12. ;
   format VAR104 best12. ;
   format VAR105 best12. ;
   format VAR106 best12. ;
   format VAR107 best12. ;
   format VAR108 best12. ;
   format VAR109 best12. ;
   format VAR110 best12. ;
   format VAR111 best12. ;
   format VAR112 best12. ;
   format VAR113 best12. ;
   format VAR114 best12. ;
   format VAR115 best12. ;
   format VAR116 best12. ;
   format VAR117 best12. ;
   format VAR118 best12. ;
   format VAR119 best12. ;
   format VAR120 best12. ;
   format VAR121 best12. ;
   format VAR122 best12. ;
   format VAR123 best12. ;
   format VAR124 best12. ;
   format VAR125 best12. ;
   format VAR126 best12. ;
   format VAR127 best12. ;
   format VAR128 best12. ;
   format VAR129 best12. ;
   format VAR130 best12. ;
   format VAR131 best12. ;
   format VAR132 best12. ;
   format VAR133 best12. ;
   format VAR134 best12. ;
   format VAR135 best12. ;
   format VAR136 best12. ;
   format VAR137 best12. ;
   format VAR138 best12. ;
   format VAR139 best12. ;
   format VAR140 best12. ;
   format VAR141 best12. ;
   format VAR142 best12. ;
   format VAR143 best12. ;
   format VAR144 best12. ;
   format VAR145 best12. ;
   format VAR146 best12. ;
   format VAR147 best12. ;
   format VAR148 best12. ;
   format VAR149 best12. ;
   format VAR150 best12. ;
   format VAR151 best12. ;
   format VAR152 best12. ;
   format VAR153 best12. ;
   format VAR154 best12. ;
   format VAR155 best12. ;
   format VAR156 best12. ;
   format VAR157 best12. ;
   format VAR158 best12. ;
   format VAR159 best12. ;
   format VAR160 best12. ;
   format VAR161 best12. ;
   format VAR162 best12. ;
   format VAR163 best12. ;
   format VAR164 best12. ;
   format VAR165 best12. ;
   format VAR166 best12. ;
   format VAR167 best12. ;
   format VAR168 best12. ;
   format VAR169 best12. ;
   format VAR170 best12. ;
   format VAR171 best12. ;
   format VAR172 best12. ;
   format VAR173 best12. ;
   format VAR174 best12. ;
   format VAR175 best12. ;
   format VAR176 best12. ;
   format VAR177 best12. ;
   format VAR178 best12. ;
   format VAR179 best12. ;
   format VAR180 best12. ;
   format VAR181 best12. ;
   format VAR182 best12. ;
   format VAR183 best12. ;
   format VAR184 best12. ;
   format VAR185 best12. ;
   format VAR186 best12. ;
   format VAR187 best12. ;
   format VAR188 best12. ;
   format VAR189 best12. ;
   format VAR190 best12. ;
   format VAR191 best12. ;
   format VAR192 best12. ;
   format VAR193 best12. ;
   format VAR194 best12. ;
   format VAR195 best12. ;
   format VAR196 best12. ;
   format VAR197 best12. ;
   format VAR198 best12. ;
   format VAR199 best12. ;
   format VAR200 best12. ;
   format VAR201 best12. ;
   format VAR202 best12. ;
   format VAR203 best12. ;
   format VAR204 best12. ;
   format VAR205 best12. ;
   format VAR206 best12. ;
   format VAR207 best12. ;
   format VAR208 best12. ;
   format VAR209 best12. ;
   format VAR210 best12. ;
   format VAR211 best12. ;
   format VAR212 best12. ;
   format VAR213 best12. ;
   format VAR214 best12. ;
   format VAR215 best12. ;
   format VAR216 best12. ;
   format VAR217 best12. ;
   format VAR218 best12. ;
   format VAR219 best12. ;
   format VAR220 best12. ;
   format VAR221 best12. ;
   format VAR222 best12. ;
   format VAR223 best12. ;
   format VAR224 best12. ;
   format VAR225 best12. ;
   format VAR226 best12. ;
   format VAR227 best12. ;
   format VAR228 best12. ;
   format VAR229 best12. ;
   format VAR230 best12. ;
   format VAR231 best12. ;
   format VAR232 best12. ;
   format VAR233 best12. ;
   format VAR234 best12. ;
   format VAR235 best12. ;
   format VAR236 best12. ;
   format VAR237 best12. ;
   format VAR238 best12. ;
   format VAR239 best12. ;
   format VAR240 best12. ;
   format VAR241 best12. ;
   format VAR242 best12. ;
   format VAR243 best12. ;
   format VAR244 best12. ;
   format VAR245 best12. ;
   format VAR246 best12. ;
   format VAR247 best12. ;
   format VAR248 best12. ;
   format VAR249 best12. ;
   format VAR250 best12. ;
   format VAR251 best12. ;
   format VAR252 best12. ;
   format VAR253 best12. ;
   format VAR254 best12. ;
   format VAR255 best12. ;
   format VAR256 best12. ;
   format VAR257 best12. ;
input
            VAR1
            VAR2
            VAR3
            VAR4
            VAR5
            VAR6
            VAR7
            VAR8
            VAR9
            VAR10
            VAR11
            VAR12
            VAR13
            VAR14
            VAR15
            VAR16
            VAR17
            VAR18
            VAR19
            VAR20
            VAR21
            VAR22
            VAR23
            VAR24
            VAR25
            VAR26
            VAR27
            VAR28
            VAR29
            VAR30
            VAR31
            VAR32
            VAR33
            VAR34
            VAR35
            VAR36
            VAR37
            VAR38
            VAR39
            VAR40
            VAR41
            VAR42
            VAR43
            VAR44
            VAR45
            VAR46
            VAR47
            VAR48
            VAR49
            VAR50
            VAR51
            VAR52
            VAR53
            VAR54
            VAR55
            VAR56
            VAR57
            VAR58
            VAR59
            VAR60
            VAR61
            VAR62
            VAR63
            VAR64
            VAR65
            VAR66
            VAR67
            VAR68
            VAR69
            VAR70
            VAR71
            VAR72
            VAR73
            VAR74
            VAR75
            VAR76
            VAR77
            VAR78
            VAR79
            VAR80
            VAR81
            VAR82
            VAR83
            VAR84
            VAR85
            VAR86
            VAR87
            VAR88
            VAR89
            VAR90
            VAR91
            VAR92
            VAR93
            VAR94
            VAR95
            VAR96
            VAR97
            VAR98
            VAR99
            VAR100
            VAR101
            VAR102
            VAR103
            VAR104
            VAR105
            VAR106
            VAR107
            VAR108
            VAR109
            VAR110
            VAR111
            VAR112
            VAR113
            VAR114
            VAR115
            VAR116
            VAR117
            VAR118
            VAR119
            VAR120
            VAR121
            VAR122
            VAR123
            VAR124
            VAR125
            VAR126
            VAR127
            VAR128
            VAR129
            VAR130
            VAR131
            VAR132
            VAR133
            VAR134
            VAR135
            VAR136
            VAR137
            VAR138
            VAR139
            VAR140
            VAR141
            VAR142
            VAR143
            VAR144
            VAR145
            VAR146
            VAR147
            VAR148
            VAR149
            VAR150
            VAR151
            VAR152
            VAR153
            VAR154
            VAR155
            VAR156
            VAR157
            VAR158
            VAR159
            VAR160
            VAR161
            VAR162
            VAR163
            VAR164
            VAR165
            VAR166
            VAR167
            VAR168
            VAR169
            VAR170
            VAR171
            VAR172
            VAR173
            VAR174
            VAR175
            VAR176
            VAR177
            VAR178
            VAR179
            VAR180
            VAR181
            VAR182
            VAR183
            VAR184
            VAR185
            VAR186
            VAR187
            VAR188
            VAR189
            VAR190
            VAR191
            VAR192
            VAR193
            VAR194
            VAR195
            VAR196
            VAR197
            VAR198
            VAR199
            VAR200
            VAR201
            VAR202
            VAR203
            VAR204
            VAR205
            VAR206
            VAR207
            VAR208
            VAR209
            VAR210
            VAR211
            VAR212
            VAR213
            VAR214
            VAR215
            VAR216
            VAR217
            VAR218
            VAR219
            VAR220
            VAR221
            VAR222
            VAR223
            VAR224
            VAR225
            VAR226
            VAR227
            VAR228
            VAR229
            VAR230
            VAR231
            VAR232
            VAR233
            VAR234
            VAR235
            VAR236
            VAR237
            VAR238
            VAR239
            VAR240
            VAR241
            VAR242
            VAR243
            VAR244
            VAR245
            VAR246
            VAR247
            VAR248
            VAR249
            VAR250
            VAR251
            VAR252
            VAR253
            VAR254
            VAR255
            VAR256
            VAR257
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

options mprint;

%macro rename;

data kdd2020.Underexpose_item_feat;
  set WORK.item_features;
  rename 
  VAR1=item_id
  %do contador=2 %to 129;
    VAR&contador=txt_vec%eval(&contador-1)
  %end;
  %do contador=130 %to 257;
    VAR&contador=img_vec%eval(&contador-129)
  %end;
  ;
run;

%mend rename;
%rename;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      06JUN20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.TRAIN_FULL_SIN_FUTURAZO    ;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\user_data\tmp_sas_data\train_full_sin_futurazo_phase_9.csv" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;

   informat user_Id best32. ;
   informat item_id best32. ;
   informat Time best32. ;
   informat phase_0 best32. ;
   informat phase_1 best32. ;
   informat phase_2 best32. ;
   informat phase_3 best32. ;
   informat phase_4 best32. ;
   informat phase_5 best32. ;
   informat phase_6 best32. ;
   informat phase_7 best32. ;
   informat phase_8 best32. ;
   informat phase_9 best32. ;
   informat item_orig $1. ;
   format user_Id best12. ;
   format item_id best12. ;
   format Time best12. ;
   format phase_0 best12. ;
   format phase_1 best12. ;
   format phase_2 best12. ;
   format phase_3 best12. ;
   format phase_4 best12. ;
   format phase_5 best12. ;
   format phase_6 best12. ;
   format phase_7 best12. ;
   format phase_8 best12. ;
   format phase_9 best12. ;
   format item_orig $1. ;
input
            user_Id
            item_id
            Time
            phase_0
            phase_1
            phase_2
            phase_3
            phase_4
            phase_5
            phase_6
            phase_7
            phase_8
            phase_9
            item_orig $
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      06JUN20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.TRAIN_Y_TEST_SIN_ULTIMO_CLICK    ;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\user_data\tmp_sas_data\train_y_test_sin_ultimo_click_phase_9.csv" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
   informat user_Id best32. ;
   informat item_id best32. ;
   informat Time best32. ;
   informat phase_0 best32. ;
   informat phase_1 best32. ;
   informat phase_2 best32. ;
   informat phase_3 best32. ;
   informat phase_4 best32. ;
   informat phase_5 best32. ;
   informat phase_6 best32. ;
   informat phase_7 best32. ;
   informat phase_8 best32. ;
   informat phase_9 best32. ;
   informat Indicador_Item_Feat best32. ;
   informat Indicador_User_Feat best32. ;
   format user_Id best12. ;
   format item_id best12. ;
   format Time best12. ;
   format phase_0 best12. ;
   format phase_1 best12. ;
   format phase_2 best12. ;
   format phase_3 best12. ;
   format phase_4 best12. ;
   format phase_5 best12. ;
   format phase_6 best12. ;
   format phase_7 best12. ;
   format phase_8 best12. ;
   format phase_9 best12. ;
   format Indicador_Item_Feat best12. ;
   format Indicador_User_Feat best12. ;
input
            user_Id
            item_id
            Time
            phase_0
            phase_1
            phase_2
            phase_3
            phase_4
            phase_5
            phase_6
            phase_7
            phase_8
            phase_9
            Indicador_Item_Feat
            Indicador_User_Feat
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      06JUN20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.VALIDACION_PHASE    ;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\user_data\tmp_sas_data\validacion_phase_9.csv" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
   informat user_Id best32. ;
   informat item_id best32. ;
   informat Time best32. ;
   informat phase_0 best32. ;
   informat phase_1 best32. ;
   informat phase_2 best32. ;
   informat phase_3 best32. ;
   informat phase_4 best32. ;
   informat phase_5 best32. ;
   informat phase_6 best32. ;
   informat phase_7 best32. ;
   informat phase_8 best32. ;
   informat phase_9 best32. ;
   informat phase best32. ;
   informat ItemDegree best32. ;
   informat item_orig $1. ;
   format user_Id best12. ;
   format item_id best12. ;
   format Time best12. ;
   format phase_0 best12. ;
   format phase_1 best12. ;
   format phase_2 best12. ;
   format phase_3 best12. ;
   format phase_4 best12. ;
   format phase_5 best12. ;
   format phase_6 best12. ;
   format phase_7 best12. ;
   format phase_8 best12. ;
   format phase_9 best12. ;
   format phase best12. ;
   format ItemDegree best12. ;
   format item_orig $1. ;
input
            user_Id
            item_id
            Time
            phase_0
            phase_1
            phase_2
            phase_3
            phase_4
            phase_5
            phase_6
            phase_7
            phase_8
            phase_9
            phase
            ItemDegree
            item_orig $
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      06JUN20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.VALIDACION_UNICO_REGISTRO    ;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\user_data\tmp_sas_data\validacion_unico_registro_phase_9.csv" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
   informat user_Id best32. ;
   informat item_id best32. ;
   informat Time best32. ;
   informat phase_0 best32. ;
   informat phase_1 best32. ;
   informat phase_2 best32. ;
   informat phase_3 best32. ;
   informat phase_4 best32. ;
   informat phase_5 best32. ;
   informat phase_6 best32. ;
   informat phase_7 best32. ;
   informat phase_8 best32. ;
   informat phase_9 best32. ;
   informat phase best32. ;
   informat ItemDegree $1. ;
   informat item_orig $1. ;
   informat target best32. ;
   format user_Id best12. ;
   format item_id best12. ;
   format Time best12. ;
   format phase_0 best12. ;
   format phase_1 best12. ;
   format phase_2 best12. ;
   format phase_3 best12. ;
   format phase_4 best12. ;
   format phase_5 best12. ;
   format phase_6 best12. ;
   format phase_7 best12. ;
   format phase_8 best12. ;
   format phase_9 best12. ;
   format phase best12. ;
   format ItemDegree $1. ;
   format item_orig $1. ;
   format target best12. ;
input
            user_Id
            item_id
            Time
            phase_0
            phase_1
            phase_2
            phase_3
            phase_4
            phase_5
            phase_6
            phase_7
            phase_8
            phase_9
            phase
            ItemDegree $
            item_orig $
            target
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/*****************************/
/* Preparación de las tablas */
/*****************************/

proc sort data=kdd2020.Train_full_sin_futurazo;
  by user_id time;
run;
quit;

proc sort data=kdd2020.Train_y_test_sin_ultimo_click;
  by user_id time;
run;
quit;

proc sort data=kdd2020.Validacion_phase;
  by user_id time;
run;
quit;

proc sort data=kdd2020.Validacion_unico_registro;
  by user_id time;
run;
quit;

/***************************************************/
/* Construcción de las tablas a puntuar para subir */
/***************************************************/

proc sql;
  create table
  kdd2020.Underexpose_train_click_&historial as
  select user_id,item_id,time from 
  kdd2020.Train_full_sin_futurazo
  where user_id 
  not in 
  (select user_id from kdd2020.Validacion_phase);
quit;

proc sort data=kdd2020.Underexpose_train_click_&historial nodupkey;
  by user_id time item_id;
run;
quit;

proc sql;
  create table
  kdd2020.Underexpose_test_click_&historial as
  select user_id,item_id,time from 
  kdd2020.Train_full_sin_futurazo
  where user_id 
  in 
  (select user_id from kdd2020.Validacion_phase);
quit;

proc sort data=kdd2020.Underexpose_test_click_&historial nodupkey;
  by user_id time item_id;
run;
quit;

data kdd2020.Underexpose_all_click_&historial;
  set
  kdd2020.Underexpose_train_click_&historial
  kdd2020.Underexpose_test_click_&historial;
  by user_id time item_id;
run;

/* Tabla de querytime */

%macro lecturaFicherosQtime(fase=);

  %do contador=0 %to &fase;

    /**********************************************************************
    *   PRODUCT:   SAS
    *   VERSION:   9.4
    *   CREATOR:   External File Interface
    *   DATE:      05APR20
    *   DESC:      Generated SAS Datastep Code
    *   TEMPLATE SOURCE:  (None Specified.)
    ***********************************************************************/
    data work.Underexpose_test_qtime_&contador;
    %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
    infile "&path.\data\underexpose_test\underexpose_test_click-&contador.\underexpose_test_qtime-&contador..csv" delimiter = ',' MISSOVER DSD lrecl=32767;
    input
                user_id
                time
    ;
    if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
    run;

  %end;

  data kdd2020.underexpose_test_qtime_&historial;
    set
    %do contador=0 %to &fase;
      work.Underexpose_test_qtime_&contador
    %end;
    ;
    by user_id time;
  run;

%mend lecturaFicherosQtime;

%lecturaFicherosQtime(fase=9);

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_train_click_0;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_train\underexpose_train_click-0.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_click_0;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-0\underexpose_test_click-0.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_qtime_0;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-0\underexpose_test_qtime-0.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_train_click_1;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_train\underexpose_train_click-1.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_click_1;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-1\underexpose_test_click-1.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_qtime_1;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-1\underexpose_test_qtime-1.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_train_click_2;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_train\underexpose_train_click-2.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_click_2;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-2\underexpose_test_click-2.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_qtime_2;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-2\underexpose_test_qtime-2.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_train_click_3;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_train\underexpose_train_click-3.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_click_3;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-3\underexpose_test_click-3.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_qtime_3;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-3\underexpose_test_qtime-3.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

data kdd2020.Underexpose_all_click_0;
  set 
  kdd2020.Underexpose_test_click_0
  kdd2020.Underexpose_train_click_0;
run;

data kdd2020.Underexpose_all_click_1;
  set 
  kdd2020.Underexpose_test_click_1
  kdd2020.Underexpose_train_click_1;
run;

data kdd2020.Underexpose_all_click_2;
  set 
  kdd2020.Underexpose_test_click_2
  kdd2020.Underexpose_train_click_2;
run;

data kdd2020.Underexpose_all_click_3;
  set 
  kdd2020.Underexpose_test_click_3
  kdd2020.Underexpose_train_click_3;
run;


/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_train_click_4;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_train\underexpose_train_click-4.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_click_4;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-4\underexpose_test_click-4.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_qtime_4;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-4\underexpose_test_qtime-4.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;


data kdd2020.Underexpose_all_click_4;
  set 
  kdd2020.Underexpose_test_click_4
  kdd2020.Underexpose_train_click_4;
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_train_click_5;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_train\underexpose_train_click-5.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_click_5;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-5\underexpose_test_click-5.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_qtime_5;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-5\underexpose_test_qtime-5.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

data kdd2020.Underexpose_all_click_5;
  set 
  kdd2020.Underexpose_test_click_5
  kdd2020.Underexpose_train_click_5;
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_train_click_6;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_train\underexpose_train_click-6.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_click_6;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-6\underexpose_test_click-6.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_qtime_6;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-6\underexpose_test_qtime-6.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

data kdd2020.Underexpose_all_click_6;
  set 
  kdd2020.Underexpose_test_click_6
  kdd2020.Underexpose_train_click_6;
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_train_click_7;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_train\underexpose_train_click-7.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_click_7;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-7\underexpose_test_click-7.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_qtime_7;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-7\underexpose_test_qtime-7.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

data kdd2020.Underexpose_all_click_7;
  set 
  kdd2020.Underexpose_test_click_7
  kdd2020.Underexpose_train_click_7;
run;


/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_train_click_8;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_train\underexpose_train_click-8.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_click_8;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-8\underexpose_test_click-8.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_qtime_8;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-8\underexpose_test_qtime-8.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

data kdd2020.Underexpose_all_click_8;
  set 
  kdd2020.Underexpose_test_click_8
  kdd2020.Underexpose_train_click_8;
run;


/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_train_click_9;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_train\underexpose_train_click-9.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_click_9;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-9\underexpose_test_click-9.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            item_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.Underexpose_test_qtime_9;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\data\underexpose_test\underexpose_test_click-9\underexpose_test_qtime-9.csv" delimiter = ',' MISSOVER DSD lrecl=32767 ;
input
            user_id
            time
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

data kdd2020.Underexpose_all_click_9;
  set 
  kdd2020.Underexpose_test_click_9
  kdd2020.Underexpose_train_click_9;
run;

/**************/
/**************/
/**************/
/* Session ID */
/**************/
/**************/
/**************/

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      05APR20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/

data kdd2020.SESSION_ID    ;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\user_data\tmp_sas_data\20200605_TABLA_FINAL_KDD_CON_SESSION.csv" delimiter = ';' MISSOVER DSD lrecl=32767 firstobs=2 ;
   informat session_id $7. ;
   informat user_Id best32. ;
   informat item_id best32. ;
   informat Time best32. ;
   informat phase_0 $1. ;
   informat phase_1 $1. ;
   informat phase_2 $1. ;
   informat phase_3 $1. ;
   informat phase_4 $1. ;
   informat phase_5 $1. ;
   informat item_orig $1. ;
   informat dif_time best32. ;
   informat log_dif_time best32. ;
   informat n_session best32. ;
   informat pos_item_in_ses best32. ;
   format session_id $7. ;
   format user_Id best12. ;
   format item_id best12. ;
   format Time best12. ;
   format phase_0 $1. ;
   format phase_1 $1. ;
   format phase_2 $1. ;
   format phase_3 $1. ;
   format phase_4 $1. ;
   format phase_5 $1. ;
   format item_orig $1. ;
   format dif_time best12. ;
   format log_dif_time best12. ;
   format n_session best12. ;
   format pos_item_in_ses best12. ;
input
            session_id $
            user_Id
            item_id
            Time
            phase_0 $
            phase_1 $
            phase_2 $
            phase_3 $
            phase_4 $
            phase_5 $
            item_orig $
            dif_time
            log_dif_time
            n_session
            pos_item_in_ses
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

data kdd2020.session_id;
  set kdd2020.session_id;
  time_c=put(compress(time),$12.);
run;

/* Se actualizan las tablas con el id_session */

%macro anayade_idSession(numfases=);

  %do contador=0 %to &numfases;

    data kdd2020.Underexpose_train_click_&contador;
      set kdd2020.Underexpose_train_click_&contador;
      time_c=put(compress(time),$12.);
    run;

    proc sql;
      create table
      kdd2020.Underexpose_train_click_&contador as
      select a.user_id,a.item_id,a.time,b.session_id from 
      kdd2020.Underexpose_train_click_&contador a
      left join
      kdd2020.session_id b
      on a.user_id=b.user_id and
      a.item_id=b.item_id and
      a.time_c=b.time_c
     ;
    quit;

    data kdd2020.Underexpose_test_click_&contador;
      set kdd2020.Underexpose_test_click_&contador;
      time_c=put(compress(time),$12.);
    run;

    proc sql;
      create table
      kdd2020.Underexpose_test_click_&contador as
      select a.user_id,a.item_id,a.time,b.session_id from 
      kdd2020.Underexpose_test_click_&contador a
      left join
      kdd2020.session_id b
      on a.user_id=b.user_id and
      a.item_id=b.item_id and
      a.time_c=b.time_c
     ;
    quit;

    data kdd2020.Underexpose_all_click_&contador;
      set kdd2020.Underexpose_all_click_&contador;
      time_c=put(compress(time),$12.);
    run;

    proc sql;
      create table
      kdd2020.Underexpose_all_click_&contador as
      select a.user_id,a.item_id,a.time,b.session_id from 
      kdd2020.Underexpose_all_click_&contador a
      left join
      kdd2020.session_id b
      on a.user_id=b.user_id and
      a.item_id=b.item_id and
      a.time_c=b.time_c
     ;
    quit;

  %end;

%mend anayade_idSession;

%anayade_idSession(numfases=9);

%macro generaTablasAcumuladas(numeroAcumulaciones=);

  %do contador=0 %to &numeroAcumulaciones;
 
    proc sort data=kdd2020.Underexpose_train_click_&contador
      out=work.tablaSalida_train_&contador nodupkey;
      by user_id time;
    run;
    quit;

    proc sort data=kdd2020.Underexpose_test_click_&contador
      out=work.tablaSalida_test_&contador nodupkey;
      by user_id time;
    run;
    quit;

    proc sort data=kdd2020.Underexpose_test_qtime_&contador
      out=work.tablaSalida_test_qtime_&contador;
      by user_id time;
    run;
    quit;

  %end;

  data kdd2020.Underexpose_train_click_0_&numeroAcumulaciones;
    set
    %do contador=0 %to &numeroAcumulaciones;
      work.tablaSalida_train_&contador
    %end;
    ;
    by user_id time;
  run;

  proc sort data=kdd2020.Underexpose_train_click_0_&numeroAcumulaciones nodupkey;
    by user_id time item_id;
  run;
  quit;

  data kdd2020.Underexpose_test_click_0_&numeroAcumulaciones;
    set
    %do contador=0 %to &numeroAcumulaciones;
      work.tablaSalida_test_&contador
    %end;
    ;
    by user_id time;
  run;

  proc sort data=kdd2020.Underexpose_test_click_0_&numeroAcumulaciones nodupkey;
    by user_id time item_id;
  run;
  quit;

  data kdd2020.Underexpose_test_qtime_0_&numeroAcumulaciones;
    set
    %do contador=0 %to &numeroAcumulaciones;
      work.tablaSalida_test_qtime_&contador
    %end;
    ;
    by user_id time;
  run;

  proc sort data=kdd2020.Underexpose_test_qtime_0_&numeroAcumulaciones nodupkey;
    by user_id time;
  run;
  quit;

  data kdd2020.Underexpose_all_click_0_&numeroAcumulaciones;
    set
    kdd2020.Underexpose_train_click_0_&numeroAcumulaciones
    kdd2020.Underexpose_test_click_0_&numeroAcumulaciones
    ;
    by user_id time;
  run;

  proc sort data=kdd2020.Underexpose_all_click_0_&numeroAcumulaciones nodupkey;
    by user_id time item_id;
  run;
  quit;

  /* Filtro */
  /* Quitamos fecha de train posteriores a fecha de qtime */

  data kdd2020.Underexpose_train_click_0_&numeroAcumulaciones(drop=qtime);
    merge kdd2020.Underexpose_train_click_0_&numeroAcumulaciones(in=a)
          kdd2020.Underexpose_test_qtime_0_&numeroAcumulaciones(rename=(time=qtime));
    by user_id;
    if a and (time<qtime or qtime eq .) then output;
  run;

  data kdd2020.Underexpose_test_click_0_&numeroAcumulaciones(drop=qtime);
    merge kdd2020.Underexpose_test_click_0_&numeroAcumulaciones(in=a)
          kdd2020.Underexpose_test_qtime_0_&numeroAcumulaciones(rename=(time=qtime));
    by user_id;
    if a and (time<qtime or qtime eq .) then output;
  run;

  data kdd2020.Underexpose_all_click_0_&numeroAcumulaciones(drop=qtime);
    merge kdd2020.Underexpose_all_click_0_&numeroAcumulaciones(in=a)
          kdd2020.Underexpose_test_qtime_0_&numeroAcumulaciones(rename=(time=qtime));
    by user_id;
    if a and (time<qtime or qtime eq .) then output;
  run;

%mend generaTablasAcumuladas;
%generaTablasAcumuladas(numeroAcumulaciones=0);
%generaTablasAcumuladas(numeroAcumulaciones=1);
%generaTablasAcumuladas(numeroAcumulaciones=2);
%generaTablasAcumuladas(numeroAcumulaciones=3);
%generaTablasAcumuladas(numeroAcumulaciones=4);
%generaTablasAcumuladas(numeroAcumulaciones=5);
%generaTablasAcumuladas(numeroAcumulaciones=6);
%generaTablasAcumuladas(numeroAcumulaciones=7);
%generaTablasAcumuladas(numeroAcumulaciones=8);
%generaTablasAcumuladas(numeroAcumulaciones=9);

/* Combinaciones usuario-items permitidas */

%macro combinacionesPermitidas(numeroPhases=,tablaSalida=);

  %do contadorPhases=0 %to &numeroPhases;

    proc sql;
      create table
      work.clicks_primera_vez_&contadorPhases as
      select item_id,min(time) as minimoTime
      from kdd2020.Underexpose_all_click_0_&contadorPhases
      group by item_id;
    quit;

    data work.clicks_primera_vez_&contadorPhases;
      set work.clicks_primera_vez_&contadorPhases;
      cruce=&contadorPhases;
    run;

    data work.Underexpose_test_qtime_&contadorPhases;
      set kdd2020.Underexpose_test_qtime_&contadorPhases;
      cruce=&contadorPhases;
    run;

    proc sql;
      create table 
      work.quitarPrimerasVeces_&contadorPhases as
      select a.user_id,b.item_id,a.cruce
      from
      work.Underexpose_test_qtime_&contadorPhases a
      inner join
      work.clicks_primera_vez_&contadorPhases b
      on a.cruce=b.cruce
      and a.time<b.minimoTime;
    quit;

    proc sort data=work.quitarPrimerasVeces_&contadorPhases nodupkey;
      by user_id item_id;
    run;
    quit;

  %end;

  data &tablaSalida;
    set
    %do contadorPhases=0 %to &numeroPhases;
      work.quitarPrimerasVeces_&contadorPhases    
    %end;
    ;
    by user_id item_id;
  run;

%mend combinacionesPermitidas;
%combinacionesPermitidas(numeroPhases=&phase,tablaSalida=kdd2020.user_item_imposibles_&historial);

/********************************************************/
/* Construcción de las tablas a puntuar para validacion */
/********************************************************/

proc sql;
  create table
  kdd2020.V_Underexpose_train_click_&historial as
  select user_id,item_id,time from 
  kdd2020.Train_y_test_sin_ultimo_click
  where user_id 
  not in 
  (select user_id from kdd2020.Validacion_phase);
quit;

proc sort data=kdd2020.V_Underexpose_train_click_&historial nodupkey;
  by user_id time item_id;
run;
quit;

%macro generaNuevaTablaTest;

  %do fase=0 %to &phase;

    data work.TEST_CLICKS_&fase;
      set kdd2020.Underexpose_test_click_&fase;
    run;

    proc sort data=work.TEST_CLICKS_&fase;
    by user_id descending time;
    run;
    quit;

    data work.NUEVA_TABLA_TEST_&fase;
    set work.TEST_CLICKS_&fase;
    by user_id;
    if not first.user_id;
    run;

  %end;

  data NUEVA_TABLA_TEST;
    set
    %do fase=0 %to &phase;
      work.NUEVA_TABLA_TEST_&fase
    %end;
    ;
  run;

%mend generaNuevaTablaTest;

%generaNuevaTablaTest;

data kdd2020.V_Underexpose_test_click_&historial;
  set NUEVA_TABLA_TEST;
run;

proc sort data=kdd2020.V_Underexpose_test_click_&historial nodupkey;
  by user_id time item_id;
run;
quit;

proc sql;
  create table
  kdd2020.V_Underexpose_train_click_&historial as
  select user_id,item_id,time from 
  kdd2020.Train_y_test_sin_ultimo_click
  where user_id 
  not in 
  (select user_id from kdd2020.Validacion_phase);
quit;

proc sort data=kdd2020.V_Underexpose_train_click_&historial nodupkey;
  by user_id time item_id;
run;
quit;

%macro generaNuevaTablaValidacion;

  %do fase=0 %to &phase;

    data work.VALIDACION_CLICKS_&fase;
      set kdd2020.Underexpose_test_click_&fase;
    run;

    proc sort data=work.VALIDACION_CLICKS_&fase;
    by user_id descending time;
    run;
    quit;

    data work.NUEVA_TABLA_VALIDACION_&fase;
    set work.VALIDACION_CLICKS_&fase;
    by user_id;
    if first.user_id;
    run;

  %end;

  data NUEVA_TABLA_VALIDACION;
    set
    %do fase=0 %to &phase;
      work.NUEVA_TABLA_VALIDACION_&fase
    %end;
    ;
  run;

%mend generaNuevaTablaValidacion;

%generaNuevaTablaValidacion;

data kdd2020.V_Underexpose_valid_click_&historial;
  set NUEVA_TABLA_VALIDACION;
run;

proc sort data=kdd2020.V_Underexpose_test_click_&historial nodupkey;
  by user_id time item_id;
run;
quit;

data kdd2020.V_Underexpose_all_click_&historial;
  set
  kdd2020.V_Underexpose_train_click_&historial
  kdd2020.V_Underexpose_test_click_&historial;
  by user_id time item_id;
run;

/**************/
/**************/
/**************/
/* Session ID */
/**************/
/**************/
/**************/

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      06JUN20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      06JUN20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.SESSION_ID    ;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\user_data\tmp_sas_data\20200605_TABLA_FINAL_KDD_CON_SESSION.csv" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2;
   informat session_id $7. ;
   informat user_Id best32. ;
   informat item_id best32. ;
   informat Time best32. ;
   informat phase_0 $1. ;
   informat phase_1 $1. ;
   informat phase_2 $1. ;
   informat phase_3 $1. ;
   informat phase_4 $1. ;
   informat phase_5 $1. ;
   informat item_orig $1. ;
   informat dif_time best32. ;
   informat log_dif_time best32. ;
   informat n_session best32. ;
   informat pos_item_in_ses best32. ;
   format session_id $7. ;
   format user_Id best12. ;
   format item_id best12. ;
   format Time best12. ;
   format phase_0 $1. ;
   format phase_1 $1. ;
   format phase_2 $1. ;
   format phase_3 $1. ;
   format phase_4 $1. ;
   format phase_5 $1. ;
   format item_orig $1. ;
   format dif_time best12. ;
   format log_dif_time best12. ;
   format n_session best12. ;
   format pos_item_in_ses best12. ;
input
            session_id $
            user_Id
            item_id
            Time
            phase_0 $
            phase_1 $
            phase_2 $
            phase_3 $
            phase_4 $
            phase_5 $
            item_orig $
            dif_time
            log_dif_time
            n_session
            pos_item_in_ses
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

data kdd2020.session_id;
  set kdd2020.session_id;
  time_c=put(compress(time),$12.);
run;

/* Se actualizan las tablas con el id_session */

data kdd2020.Underexpose_train_click_&historial;
  set kdd2020.Underexpose_train_click_&historial;
  time_c=put(compress(time),$12.);
run;

proc sql;
  create table
  kdd2020.Underexpose_train_click_&historial as
  select a.user_id,a.item_id,a.time,b.session_id from 
  kdd2020.Underexpose_train_click_&historial a
  left join
  kdd2020.session_id b
  on a.user_id=b.user_id and
  a.item_id=b.item_id and
  a.time_c=b.time_c
 ;
quit;

data kdd2020.Underexpose_test_click_&historial;
  set kdd2020.Underexpose_test_click_&historial;
  time_c=put(compress(time),$12.);
run;

proc sql;
  create table
  kdd2020.Underexpose_test_click_&historial as
  select a.user_id,a.item_id,a.time,b.session_id from 
  kdd2020.Underexpose_test_click_&historial a
  left join
  kdd2020.session_id b
  on a.user_id=b.user_id and
  a.item_id=b.item_id and
  a.time_c=b.time_c
 ;
quit;

data kdd2020.Underexpose_all_click_&historial;
  set kdd2020.Underexpose_all_click_&historial;
  time_c=put(compress(time),$12.);
run;

proc sql;
  create table
  kdd2020.Underexpose_all_click_&historial as
  select a.user_id,a.item_id,a.time,b.session_id from 
  kdd2020.Underexpose_all_click_&historial a
  left join
  kdd2020.session_id b
  on a.user_id=b.user_id and
  a.item_id=b.item_id and
  a.time_c=b.time_c
 ;
quit;

/* Y validación */

data kdd2020.V_Underexpose_train_click_&historial;
  set kdd2020.V_Underexpose_train_click_&historial;
  time_c=put(compress(time),$12.);
run;

proc sql;
  create table
  kdd2020.V_Underexpose_train_click_&historial as
  select a.user_id,a.item_id,a.time,b.session_id from 
  kdd2020.V_Underexpose_train_click_&historial a
  left join
  kdd2020.session_id b
  on a.user_id=b.user_id and
  a.item_id=b.item_id and
  a.time_c=b.time_c
 ;
quit;

data kdd2020.V_Underexpose_test_click_&historial;
  set kdd2020.V_Underexpose_test_click_&historial;
  time_c=put(compress(time),$12.);
run;

proc sql;
  create table
  kdd2020.V_Underexpose_test_click_&historial as
  select a.user_id,a.item_id,a.time,b.session_id from 
  kdd2020.V_Underexpose_test_click_&historial a
  left join
  kdd2020.session_id b
  on a.user_id=b.user_id and
  a.item_id=b.item_id and
  a.time_c=b.time_c
 ;
quit;

data kdd2020.V_Underexpose_all_click_&historial;
  set kdd2020.V_Underexpose_all_click_&historial;
  time_c=put(compress(time),$12.);
run;

proc sql;
  create table
  kdd2020.V_Underexpose_all_click_&historial as
  select a.user_id,a.item_id,a.time,b.session_id from 
  kdd2020.V_Underexpose_all_click_&historial a
  left join
  kdd2020.session_id b
  on a.user_id=b.user_id and
  a.item_id=b.item_id and
  a.time_c=b.time_c
 ;
quit;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      06JUN20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.TABLA_VALIDACION_PHASE9    ;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path/user_data/tablas_boosting/tabla_validacion_phase_9.csv" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2  firstobs=2;

   informat phase best32. ;
   informat user_id best32. ;
   informat item_id best32. ;
   informat item_degree best32. ;
   informat es_half best32. ;
   format phase best12. ;
   format user_id best12. ;
   format item_id best12. ;
   format item_degree best12. ;
   format es_half best12. ;
input
            phase
            user_id
            item_id
            item_degree
            es_half
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;
