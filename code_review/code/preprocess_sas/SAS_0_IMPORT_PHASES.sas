
%MACRO importacion;


	proc import datafile="&ruta.\data\underexpose_train\underexpose_item_feat.csv" out=work.item_feat dbms=dlm replace;
	delimiter=",";
	getnames=no; 
	/*guessingrows=MAX;*/
	run;
	quit;

	%MACRO RENAME_TXT_VEC;
		%DO i=2 %TO 129;
			var&i = txt_vec_%sysevalf(&i.-1)
		%END;
	%MEND RENAME_TXT_VEC;

	%MACRO RENAME_IMG_VEC;

		%DO i=130 %TO 257;
			var&i = img_vec_%sysevalf(&i.-129)
		%END;
	%MEND RENAME_IMG_VEC;

	options nomprint;
	data data.item_feat(rename=(TXT_VEC_1_NUM=txt_vec_1 TXT_VEC_128_NUM=txt_vec_128
								img_vec_1_NUM = img_vec_1 img_vec_128_NUM = img_vec_128 )) ;
		set work.item_feat(rename=(var1=item_id
				%RENAME_TXT_VEC
				%RENAME_IMG_VEC
				));
		TXT_VEC_1_NUM = INPUT(SUBSTR(TXT_VEC_1, 2), 8.);
		TXT_VEC_128_NUM = INPUT(SUBSTR(TXT_VEC_128, 1, length(img_vec_128)-1), 8.);
		img_vec_1_NUM = INPUT(SUBSTR(img_vec_1,2), 8.);
		img_vec_128_NUM = INPUT(SUBSTR(img_vec_128, 1, length(img_vec_128)-1), 8.);

		drop TXT_VEC_1 txt_vec_128 img_vec_1 img_vec_128;
		format _numeric_ best32.;
	run;



	/*
	user_id：the unique identifier of the user
	user_age_level：the age group to which the user belongs
	user_gender：the gender of the user, which can be empty
	user_city_level：the tier to which the user's city belongs
	*/

	proc import datafile="&ruta.\data\underexpose_train\underexpose_user_feat.csv" out=data.user_feat(rename=(var1=user_id 
			var2=user_age_level var3=user_gender var4=user_city_level)) 
	dbms=dlm replace;
	delimiter=",";
	getnames=no; 
	run;
	quit;


	%do cont_phase=0 %to 9;

		proc import datafile="&ruta.\data\underexpose_train\underexpose_train_click-&cont_phase..csv" 
		out=data.train_click_&cont_phase.(rename=(var1=user_id var2=item_id
		var3=time)) dbms=dlm replace;
		delimiter=",";
		getnames=no; 
		run;
		quit;

		data data.train_click_&cont_phase.;
			set data.train_click_&cont_phase.;
			format time best32.;
		run;

		proc import datafile="&ruta.\data\underexpose_test\underexpose_test_click-&cont_phase.\underexpose_test_click-&cont_phase..csv" 
		out=data.test_click_&cont_phase.(rename=(var1=user_id var2=item_id
		var3=time)) dbms=dlm replace;
		delimiter=",";
		getnames=no; 
		run;
		quit;

		data data.test_click_&cont_phase.;
			set data.test_click_&cont_phase.;
			format time best32.;
		run;

		proc import datafile="&ruta.\data\underexpose_test\underexpose_test_click-&cont_phase.\underexpose_test_qtime-&cont_phase..csv" 
		out=data.test_qtime_&cont_phase.(rename=(var1=user_id var2=query_time))
				dbms=dlm replace;		
		delimiter=",";
		getnames=no; 
		run;
		quit;

		data data.test_qtime_&cont_phase.;
			set data.test_qtime_&cont_phase.;
		format query_time best32.;
		run;
	%end;

%mend importacion;

%importacion;