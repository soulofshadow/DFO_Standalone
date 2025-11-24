
function SkillCoolTimeUI ( obj )
{


	local skillmgr = obj.getSkillManager ( );
	local apd = getComboUiAppendage ( obj );
	if ( !apd )
		return false;

	local currentT = apd.getTimer ( ).Get ( );
	local offsetX = 0;
	local offsetY = 0;

	if ( apd.getVar ( "saveSkillOkTime" ).size_vector ( ) == 0 )
	{
		apd.getVar ( "saveSkillOkTime" ).clear_vector ( );
		for ( local i = 0; i < 255; i++ )
			apd.getVar ( "saveSkillOkTime" ).push_vector ( -1 );

		apd.getVar ( "saveCurrentSklTime" ).clear_vector ( );
		for ( local i = 0; i < 255; i++ )
			apd.getVar ( "saveCurrentSklTime" ).push_vector ( -1 );
	}
	if ( obj.getVar("nskEnd").getBool(0) ){
		if(NewSkillCoolTimeEndAni( obj, true)){
			obj.getVar("nskEnd").setBool(0,false);
		}
	}
	if ( obj.getVar("nskEnd").getBool(1) ){
		if(NewSkillCoolTimeEndAni( obj, false)){
			obj.getVar("nskEnd").setBool(1,false);
		}
	}

	for ( local i = 1; i < 255; i++ )
	{
		local skl = sq_GetSkill ( obj, i );
		if ( skl )
		{
			local isCool = skl.isInCoolTime ( );
			if ( isCool )
			{
				if ( apd.getVar ( "saveSkillOkTime" ).get_vector ( i ) == -1 )
				{
					apd.getVar ( "saveSkillOkTime" ).set_vector ( i, currentT );
					apd.getVar ( "saveCurrentSklTime" ).set_vector ( i, skl.getCoolTime ( obj, -1 ) );
				}
				else
				{
					local id = skillmgr.getSlotindex ( i );
					local newidc = obj.getVar("newslotindex").getInt(1);
					local newida = obj.getVar("newslotindex").getInt(0);
					//printp("c:"+newidc+"a:"+newida+"\n\r");
					if ( ( id >= 0 && id < 6 ) )
					{

						local coolTime = apd.getVar ( "saveCurrentSklTime" ).get_vector ( i );
						local curCoolTime = coolTime - ( currentT - apd.getVar ( "saveSkillOkTime" ).get_vector ( i ) );
						if ( curCoolTime >= 10000 )
							drawSirocoUINumberWithPos ( obj, 685 + id * 30, 570, curCoolTime / 1000 );
						else
							drawSirocoUINumberWithPosPoint ( obj, 685 + id * 30, 570, curCoolTime / 100 );
					}
					else if ( ( id >= 198 && id < 204 ) )
					{
						local id = id - 198;
						local coolTime = apd.getVar ( "saveCurrentSklTime" ).get_vector ( i );
						local curCoolTime = coolTime - ( currentT - apd.getVar ( "saveSkillOkTime" ).get_vector ( i ) );
						if ( curCoolTime >= 10000 )
							drawSirocoUINumberWithPos ( obj, 685 + id * 30, 532, curCoolTime / 1000 );
						else
							drawSirocoUINumberWithPosPoint ( obj, 685 + id * 30, 532, curCoolTime / 100 );
					}
					else if(newidc>0&&newidc==i)
					{
						local coolTime = apd.getVar ( "saveCurrentSklTime" ).get_vector ( i );
						local curCoolTime = coolTime - ( currentT - apd.getVar ( "saveSkillOkTime" ).get_vector ( i ) );
						NewSkillCoolTimeShadow( obj, coolTime,curCoolTime, false);
						if ( curCoolTime >= 10000 ){
							drawSirocoUINumberWithPos ( obj, 1045, 422, curCoolTime / 1000 );
						}
						else{
							if(curCoolTime < 100)
							{
								obj.getVar("nskEnd").setBool(1,true);
								//NewSkillCoolTimeEndAni( obj, false);
							}
							drawSirocoUINumberWithPosPoint ( obj, 1045, 422, curCoolTime / 100 );	
						}

					}
					else if(newida>0&&newida==i)
					{
						local coolTime = apd.getVar ( "saveCurrentSklTime" ).get_vector ( i );
						local curCoolTime = coolTime - ( currentT - apd.getVar ( "saveSkillOkTime" ).get_vector ( i ) );
						NewSkillCoolTimeShadow( obj, coolTime,curCoolTime, true);
						if ( curCoolTime >= 10000 ){
							drawSirocoUINumberWithPos ( obj, 1045, 452, curCoolTime / 1000 );
						}
						else{
							if(curCoolTime < 100)
							{
								obj.getVar("nskEnd").setBool(0,true);
								//NewSkillCoolTimeEndAni( obj, true);
							}
							drawSirocoUINumberWithPosPoint ( obj, 1045, 452, curCoolTime / 100 );	
						}
					}
					else
					{
						
						local coolTime = apd.getVar ( "saveCurrentSklTime" ).get_vector ( i );
						local curCoolTime = coolTime - ( currentT - apd.getVar ( "saveSkillOkTime" ).get_vector ( i ) );

						local lastX = 671 + offsetX;
						local lastY = 485 + offsetY;
						sq_DrawSkillIcon ( skl, lastX, lastY, sq_ALPHA ( 100 ) );

						if ( curCoolTime >= 10000 )
							drawSirocoUINumberWithPos ( obj, lastX + 11, lastY + 10, curCoolTime / 1000 );
						else
							drawSirocoUINumberWithPosPoint ( obj, lastX + 11, lastY + 10, curCoolTime / 100 );

						if ( offsetX <= 150 ){
							offsetX += 30;						
						}
						else
						{
							offsetX = 0;
							offsetY -= 30;
						}
					}

				}
			}
			else
			{
				if ( apd.getVar ( "saveSkillOkTime" ).get_vector ( i ) != -1 )
				{
					apd.getVar ( "saveSkillOkTime" ).set_vector ( i, -1 );
				}
				else
				{

				}

			}

		}
	}
	//local Img_Alt = sq_CreateAnimation("", "sqr/custom/ani/skillicon/alt.ani");
	//sq_AnimationProc(Img_Alt);
	//sq_drawCurrentFrame(Img_Alt, 493, 576, false);
	//local Img_Ctrl = sq_CreateAnimation("", "sqr/custom/ani/skillicon/ctrl.ani");
	//sq_AnimationProc(Img_Ctrl);
	//sq_drawCurrentFrame(Img_Ctrl, 493, 546, false);
}


function getComboUiAppendage ( obj )
{
	return obj.GetSquirrelAppendage ( "apjh/currency.nut" );
}


function drawSirocoUINumberWithPos ( obj, x, y, var )
{

	if ( var == 0 )
	{
		local ani = getSirocoUINumber ( obj, 0 );
		sq_AnimationProc ( ani );
		sq_drawCurrentFrame ( ani, x, y, false );
		//sq_Rewind(ani);
		return false;
	}

	local saveVar = var;
	local saveVar2 = var;
	local offsetX = 0;
	local centerX = 0;

	while ( saveVar2 > 0 )
	{
		saveVar2 = saveVar2 / 10;
		centerX += 5;
	}

	while ( saveVar > 0 )
	{
		local v = saveVar % 10;
		local ani = getSirocoUINumber ( obj, v );
		sq_AnimationProc ( ani );
		sq_drawCurrentFrame ( ani, x + offsetX, y, false );
		
		offsetX = offsetX - 5;
		saveVar = saveVar / 10;

	}
	//sq_Rewind(ani);


}

function getSirocoUINumber ( obj, var )
{
	local numImage = null;
	local sq_var = obj.getVar ( );
	var = var % 10;

	numImage = sq_var.GetAnimationMap ( "SirocoUINumber" + var,
		"common/skillcooltime/" + var + ".ani" );

	return numImage;
}


function drawSirocoUINumberWithPosPoint ( obj, x, y, var )
{

	if ( var < 0 )
	{
		return false;
	}

	local offsetX = 0;
	local centerX = 0;

	local shi = var / 10;
	local ge = var % 10;

	local ani = getSirocoUINumber ( obj, ge );
	sq_AnimationProc ( ani );
	sq_drawCurrentFrame ( ani, x + offsetX, y, false );
	offsetX = offsetX - 7;

	ani = getSirocoUINumber ( obj, shi );
	sq_AnimationProc ( ani );
	sq_drawCurrentFrame ( ani, x + offsetX, y, false );
	//sq_Rewind(ani);
}

function NewSkillCoolTimeShadow( obj, coolTime,curCoolTime, alt){
	if ( !obj )
		return;
	local nx = 1030;
	local ny = 416;
	if(alt==true){
		ny=ny+31;
	}
	local shadow = sq_CreateAnimation("", "sqr/custom/ani/skillicon/disable.ani");
	sq_AnimationProc(shadow);
	local per = curCoolTime*100/coolTime;
	if(per>4){
		sq_drawCurrentFrame(shadow, nx, ny, false);
	}
	else{
		sq_Rewind(shadow);
	}
	if(per>8){
		sq_drawCurrentFrame(shadow, nx, ny+1, false);}
	if(per>11){
		sq_drawCurrentFrame(shadow, nx, ny+2, false);}
	if(per>15){
		sq_drawCurrentFrame(shadow, nx, ny+3, false);}
	if(per>18){
		sq_drawCurrentFrame(shadow, nx, ny+4, false);}
	if(per>22){
		sq_drawCurrentFrame(shadow, nx, ny+5, false);}
	if(per>25){
		sq_drawCurrentFrame(shadow, nx, ny+6, false);}
	if(per>29){
		sq_drawCurrentFrame(shadow, nx, ny+7, false);}
	if(per>33){
		sq_drawCurrentFrame(shadow, nx, ny+8, false);}
	if(per>36){
		sq_drawCurrentFrame(shadow, nx, ny+9, false);}
	if(per>39){
		sq_drawCurrentFrame(shadow, nx, ny+10, false);}
	if(per>43){
		sq_drawCurrentFrame(shadow, nx, ny+11, false);}
	if(per>47){
		sq_drawCurrentFrame(shadow, nx, ny+12, false);}
	if(per>50){
		sq_drawCurrentFrame(shadow, nx, ny+13, false);}
	if(per>54){
		sq_drawCurrentFrame(shadow, nx, ny+14, false);}
	if(per>57){
		sq_drawCurrentFrame(shadow, nx, ny+15, false);}
	if(per>61){
		sq_drawCurrentFrame(shadow, nx, ny+16, false);}
	if(per>65){
		sq_drawCurrentFrame(shadow, nx, ny+17, false);}
	if(per>68){
		sq_drawCurrentFrame(shadow, nx, ny+18, false);}
	if(per>72){
		sq_drawCurrentFrame(shadow, nx, ny+19, false);}
	if(per>75){
		sq_drawCurrentFrame(shadow, nx, ny+20, false);}
	if(per>79){
		sq_drawCurrentFrame(shadow, nx, ny+21, false);}
	if(per>82){
		sq_drawCurrentFrame(shadow, nx, ny+22, false);}
	if(per>85){
		sq_drawCurrentFrame(shadow, nx, ny+23, false);}
	if(per>89){
		sq_drawCurrentFrame(shadow, nx, ny+24, false);}
	if(per>93){
		sq_drawCurrentFrame(shadow, nx, ny+25, false);
	}
	if(per>95){
		sq_drawCurrentFrame(shadow, nx, ny+26, false);
	}
		
	if(per>98){
		sq_drawCurrentFrame(shadow, nx, ny+27, false);}
	//sq_Rewind(shadow);
	return;
}

function NewSkillCoolTimeEndAni(obj, alt){
	if ( !obj )
		return;
	local nx = 1030;
	local ny = 386;
	local name = "nskC";
	if(alt==true){
		ny=ny+31;
		name = "nskA";
	}
	local end = obj.getVar().GetAnimationMap(name, "sqr/custom/ani/skillicon/cooltimeend.ani");
	sq_AnimationProc(end);
	sq_drawCurrentFrame(end, nx, ny+27, false);
	if(sq_IsEnd(end)){
		sq_Rewind(end);
		return true;
	}
	return false;
}
