bloodValue <- 0

function drawCustomUI_ATMage(obj)
{
	if(!obj) return;
	if(!obj || sq_isPVPMode()) return;
	drawBloodMageEnergyAbsortEffect(obj);
    drawBreakSenseCustomUI(obj);
	drawBloodMageUI(obj);
	return;
}

function setCharacterFristAnimation_ATMage(obj) {
	if (!obj) return;
	if (sq_getJob(obj) != 8)
		return false;
	setCharacterFristAnimation_Corruption(obj);
	setCharacterFristAnimation_RumbleDog(obj);
	setCharacterFristAnimation_Fang(obj);
	setCharacterFristAnimation_Lilroi(obj);
	setCharacterFristAnimation_HellBerus(obj);
	setCharacterFristAnimation_Torment(obj);
	setCharacterFristAnimation_Fatality(obj);
	setCharacterFristAnimation_Offering(obj);
	setCharacterFristAnimation_SoulSteel(obj);
	setCharacterFristAnimation_BloodStream(obj);
	setCharacterFristAnimation_Tepes(obj);
	setCharacterFristAnimation_BloodWing(obj);
	setCharacterFristAnimation_PhatomBale(obj);
	setCharacterFristAnimation_Marauder(obj);
	setCharacterFristAnimation_BrokenArrow(obj);
}

function setActiveStatus_ATMage(obj, activeStatus, power)
{
	if(!obj) return;
	createDamageRateByTargetAndID(obj,obj,1,power,0,1,0);
	return 1;
}

function drawBloodMageEnergyAbsortEffect(obj)
{
	if(!obj) return;

    if (!CNSquirrelAppendage.sq_IsAppendAppendage(obj, "character/atmage/append_bloodmage/ap_bloodmage_gauge.nut"))
    {
        local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, 
        SKILL_BLOODONE, false, "character/atmage/append_bloodmage/ap_bloodmage_gauge.nut", true);	

    }

    local apd = obj.GetSquirrelAppendage("character/atmage/append_bloodmage/ap_bloodmage_gauge.nut");
    local curT = apd.getTimer().Get();
    local sq_var = obj.getVar();

    local objectManager = obj.getObjectManager();
    local xPos = objectManager.getFieldXPos(0, ENUM_DRAWLAYER_NORMAL); //  mapX Pos


    for (local i = 0;i< 25 ;i++)
    {

        if (apd.getVar("EnergyParameter").get_vector(i * 3) != -1 )
        {

//                sq_AddMessage(29002); 
            local t = apd.getVar("EnergyParameter").get_vector(i * 3);
            local currentT = curT - t;
            if (currentT < 700)
            {

                local startX = apd.getVar("EnergyParameter").get_vector(i * 3 + 1) / 100;
                local startY = apd.getVar("EnergyParameter").get_vector(i * 3 + 2) / 1000;
                local startZ = apd.getVar("EnergyParameter").get_vector(i * 3 + 2) % 1000;
                local random = apd.getVar("EnergyParameter").get_vector(i * 3 + 1) % 100;

                local yPos = objectManager.getFieldYPos(0, startZ , ENUM_DRAWLAYER_NORMAL);//mapY Pos

                local screenX = startX - xPos;
                local screenY = startY - yPos;


                local x = getBloodMageEnergyAbsortBeizeriCntPosX(obj,screenX,currentT,i,random);
                local y = getBloodMageEnergyAbsortBeizeriCntPosY(obj,screenY,currentT,i,random);

                for (local j = 1;j< 15 ;j++)
                {
                    local xHead = getBloodMageEnergyAbsortBeizeriCntPosX(obj,screenX,currentT - 5 * j,i,random);
                    local yHead = getBloodMageEnergyAbsortBeizeriCntPosY(obj,screenY,currentT - 5 * j,i,random );
                    local xTail = getBloodMageEnergyAbsortBeizeriCntPosX(obj,screenX,currentT - 5 * (j + 1),i,random );
                    local yTail = getBloodMageEnergyAbsortBeizeriCntPosY(obj,screenY,currentT - 5 * (j + 1),i,random );

                    local offsetX = xTail - xHead;
                    local offsetY = yTail - yHead;

                    local angle = -sq_Atan2( offsetY.tofloat(), offsetX.tofloat());
                    local ani = sq_var.GetAnimationMap("BloodMageEnegryTailObj", 
                    "character/mage/atanimation/als_ani/atblood/balltail4.ani");
//                    local ani = GetBloodMageAbsortEnergyTailAni(obj,j);

                    sq_SetfRotateAngle(ani, angle);
//                    ani.setImageRate(offsetY.tofloat() / 9.0 ,offsetX.tofloat() / 4.5);
                    sq_AnimationProc(ani);
                    sq_drawCurrentFrame(ani, xHead, yHead, false);
                }

                local ani = sq_var.GetAnimationMap("BloodMageEnegryHeadObj", 
                "character/mage/atanimation/als_ani/atblood/ballhead.ani");
                sq_AnimationProc(ani);
                sq_drawCurrentFrame(ani, x, y, false);

//                sq_DrawSpecificFrame(hudCreatorAni, 400, 300, false, 0, false, 1.0);



            }else{
                CreateBloodMageAbsortBloodEffect(obj);
                apd.getVar("EnergyParameter").set_vector(i * 3,-1);
                apd.getVar("EnergyParameter").set_vector(i * 3 + 1,-1);
                apd.getVar("EnergyParameter").set_vector(i * 3 + 2,-1);
            }


        }
    }

}


function GetBloodMageAbsortEnergyTailAni(obj,id)
{
	if(!obj) return;
    local sq_var = obj.getVar();
    local ani = null;
    if (id == 1)
    {
        ani = sq_var.GetAnimationMap("BloodMageEnegryTailObj1", 
                    "character/mage/atanimation/als_ani/atblood/balltail4.ani");
    }else if (id == 2)
    {
        ani = sq_var.GetAnimationMap("BloodMageEnegryTailObj2", 
                    "character/mage/atanimation/als_ani/atblood/balltail4.ani");
    }else if (id == 3)
    {
        ani = sq_var.GetAnimationMap("BloodMageEnegryTailObj3", 
                    "character/mage/atanimation/als_ani/atblood/balltail4.ani");
    }else if (id >= 4)
    {
        ani = sq_var.GetAnimationMap("BloodMageEnegryTailObj4", 
                    "character/mage/atanimation/als_ani/atblood/balltail4.ani");
    }
    return ani;
}


function CreateBloodMageAbsortBloodEffect(obj)
{
	if(!obj) return;
    if (obj)
    {

        local ani = sq_CreateAnimation("","character/mage/atanimation/als_ani/atblood/absorbblood02.ani");
        local pooledObj = sq_CreatePooledObject(ani,true);
        pooledObj.setCurrentPos(obj.getXPos() ,obj.getYPos() + 1,obj.getZPos() + obj.getObjectHeight()/2 );
        pooledObj.setCurrentDirection(obj.getDirection());
        sq_AddObject(obj,pooledObj,2,false);	

    }
}







function procSkill_BloodOne(obj)
{
	if(!obj) return;
    if (obj.sq_GetSkillLevel(SKILL_BLOODONE) > 0)
    {
        if (!CNSquirrelAppendage.sq_IsAppendAppendage(obj, "character/atmage/bloodone/ap_bloodone2.nut"))
        {
            local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, 
            SKILL_BLOODONE, false, "character/atmage/bloodone/ap_bloodone2.nut", true);	


        }
    }else{

        if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, "character/atmage/bloodone/ap_bloodone2.nut"))    
        {

            CNSquirrelAppendage.sq_RemoveAppendage(obj, "character/atmage/bloodone/ap_bloodone2.nut");
        }
    }
}


function isExcutableState_ATMage(obj, skill_index)
{
    return true;

}


function setBloodTailObjEffect(obj,damager)
{

}


function onProcSkill_Fate(obj)
{

    if (sq_GetSkillLevel(obj, SKILL_FATE_0 ) > 0)
    {

    }

}


function setCustomHitEffectBloodMageCut(obj,damager,spinRate)
{
	if(!obj) return;
	if (damager)
	{
		local ani = sq_AddDrawOnlyAniFromParent(damager, "passiveobject/zrr_skill/atmage/animation/hiteffect/bloodslashsmall1.ani", 0, 1, damager.getObjectHeight()/2);
		local rand = sq_getRandom(0,3).tointeger();
		if (rand > 2)
			ani = sq_AddDrawOnlyAniFromParent(damager, "passiveobject/zrr_skill/atmage/animation/hiteffect/bloodslashsmall2.ani", 0, 1, damager.getObjectHeight()/2);
		else if (rand > 1)
			ani = sq_AddDrawOnlyAniFromParent(damager, "passiveobject/zrr_skill/atmage/animation/hiteffect/bloodslashsmall3.ani", 0, 1, damager.getObjectHeight()/2);

		//local pooledObj = sq_CreatePooledObject(ani,true);
		//pooledObj.setCurrentPos(damager.getXPos() ,damager.getYPos() + 1,damager.getZPos() + damager.getObjectHeight()/2 );
		//pooledObj.setCurrentDirection(damager.getDirection());
		//sq_AddObject(obj,pooledObj,2,false);	
        
		sq_moveWithParent(damager, ani);
        
	}
}




function setCustomHitEffectBloodMageBlow(obj,damager)
{
/*
    if (damager)
    {

        local ani = sq_CreateAnimation("","passiveobject/zrr_skill/atmage/animation/hiteffect/bloodknocklarge.ani");
        local pooledObj = sq_CreatePooledObject(ani,true);
        pooledObj.setCurrentPos(damager.getXPos() ,damager.getYPos() + 1,damager.getZPos() + damager.getObjectHeight()/2 );
        pooledObj.setCurrentDirection(damager.getDirection());
        sq_AddObject(obj,pooledObj,2,false);	

    }
*/
}


function isEventHorizen(obj)
{
	if(!obj) return false;
    return CNSquirrelAppendage.sq_IsAppendAppendage(obj, "character/atmage/eventhorizen/ap_eventhorizen.nut");
}

function removeEventHorizen(obj)
{
    CNSquirrelAppendage.sq_RemoveAppendage(obj, "character/atmage/eventhorizen/ap_eventhorizen.nut");
}

function isBreakSense(obj)
{
	if(!obj) return false;
    return CNSquirrelAppendage.sq_IsAppendAppendage(obj, "character/atmage/breaksense/ap_breaksense.nut");
}

function onStartMap_ATMage(obj)
{
	if(!obj) return;
    local job = getNyarly(obj);
    if (job)
    {
            job.getVar("state").clear_vector();
            job.getVar("state").push_vector(0);
            local pIntVec = sq_GetGlobalIntVector();
            sq_IntVectorClear(pIntVec);
            sq_IntVectorPush(pIntVec, 0);
            job.addSetStatePacket(10, pIntVec, STATE_PRIORITY_AUTO, false, "");

            
            obj.sq_SendCreatePassiveObjectPacket(152237 , 0, 100, 1, 0);


    }
}

function getNyarly(obj)
{
	if(!obj) return;
    local dot = obj.getMyPassiveObject(24342,0);
    if (dot)
    {
        return dot;
    }
    return null;
}


function getParticleVoid(obj)
{
	if(!obj) return;
    local dot = obj.getMyPassiveObject(24343,0);
    if (dot)
    {
        return dot;
    }
    return null;
}


function getBreakSenseEnegry(obj)
{
	if(!obj) return 0;
    if (isBreakSense(obj))
    {
        local apd = obj.GetSquirrelAppendage("character/atmage/breaksense/ap_breaksense.nut");
        return apd.getVar("nullValue").get_vector(0);

    }
    return 0;
}

function setBreakSenseEnegry(obj,value)
{
	if(!obj) return 0;
    if (isBreakSense(obj))
    {
        local apd = obj.GetSquirrelAppendage("character/atmage/breaksense/ap_breaksense.nut");
        if (getBreakSenseEnegry(obj) < value)
        {
            //increare
            apd.getVar("state").set_vector(0,1);
            apd.getVar("t").set_vector(0, apd.getTimer().Get() );


            //appendage.getTimer().Get();


        }else if (getBreakSenseEnegry(obj) > value)
        {
            //decreare
//            apd.getVar("state").set_vector(0,2);
//            apd.getVar("t").set_vector(0, apd.getTimer().Get() );
        }

        local maxSth = obj.sq_GetIntData(SKILL_BREAKSENSE, 1);
        local maxEnegry = obj.sq_GetIntData(SKILL_BREAKSENSE, 0);

        if (sq_GetSkillLevel(obj, SKILL_STH_0) > 0)
            maxSth += sq_GetLevelData(obj, SKILL_STH_0, 1, sq_GetSkillLevel(obj, SKILL_STH_0) );


        if ((maxSth + 1) * maxEnegry - 1 < value)
        {
            apd.getVar("nullValue").set_vector(0,(maxSth + 1) * maxEnegry - 1 );
        }else{
            apd.getVar("nullValue").set_vector(0, value);
        }


    }
    return 0;
}



function getBloodMageEnergyAbsortBeizeriCntPosX(obj,screenX,currentT,i,random)
{
    if (currentT < 0 || currentT > 400)
        return - 999;
    local var = sq_GetUniformVelocity(0, 100, currentT, 400);
    local CscreenX = sq_GetScreenXPos(obj);
    local radion1X = 0 + random * 2;
    local radion2X = CscreenX;
    if (screenX > CscreenX)
    {
        radion1X = 700 + random * 2;
        radion2X = CscreenX;
    }
    local var = getBeizeriCnt(obj,var,100,screenX,radion1X, radion2X ,CscreenX).tointeger();

    return var;

}

function getBloodMageEnergyAbsortBeizeriCntPosY(obj,screenY,currentT,i,random)
{
    if (currentT < 0 || currentT > 400)
        return - 999;
    local var = sq_GetUniformVelocity(0, 100, currentT, 400);
    local CscreenY = sq_GetScreenYPos(obj) - obj.getObjectHeight()/2;;
    local radion1Y = 50;
    local radion2Y = 300;
  
    if (i % 2 == 1)
    {
        radion1Y = 200;
        radion2Y = 200;
    }else{
        radion1Y = 400;
        radion2Y = 400;
    }


    local var = getBeizeriCnt(obj,var,100,screenY,radion1Y,radion2Y,CscreenY).tointeger();

    return var;

}


function proc_ParticleVoid(obj)
{
    local skill_level = sq_GetSkillLevel(obj, SKILL_PARTICLE_VOLD);
	if(skill_level > 0)
	{

        if (!CNSquirrelAppendage.sq_IsAppendAppendage(obj, "character/atmage/particlevoid/ap_particle_void.nut") )
        {
            local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_PARTICLE_VOLD, false, 
				"character/atmage/particlevoid/ap_particle_void.nut", true);

//            appendage.setAppendCauseSkill(BUFF_CAUSE_SKILL, sq_getJob(obj), SKILL_BREAKSENSE, skill_level);
//            CNSquirrelAppendage.sq_AppendAppendageID(appendage, obj, obj, SKILL_BREAKSENSE, true);

        }

    }
}


function proc_BreakSense(obj)
{
    local skill_level = sq_GetSkillLevel(obj, SKILL_BREAKSENSE);
	if(skill_level > 0)
	{

        if (!isBreakSense(obj) )
        {
            local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_BREAKSENSE , false, 
				"character/atmage/breaksense/ap_breaksense.nut", true);

            appendage.setAppendCauseSkill(BUFF_CAUSE_SKILL, sq_getJob(obj), SKILL_BREAKSENSE, skill_level);
            CNSquirrelAppendage.sq_AppendAppendageID(appendage, obj, obj, SKILL_BREAKSENSE, true);

        }

    }
}


function getBreakSenseMagicStoneCount(obj)
{
	if(!obj) return;
    local energy = getBreakSenseEnegry(obj);
    local maxEnegry = obj.sq_GetIntData(SKILL_BREAKSENSE, 0);
    return (energy / maxEnegry).tointeger();

}



function getBreakSenseStoneNumberAni(obj,num)
{
    local numImage = null;
    local sq_var = obj.getVar();
    if (num == 0)
    {
        numImage = sq_var.GetAnimationMap("SenseStonenum0", "character/mage/atanimation/als_ani/atoversense/ui/number/0.ani");
    }else if (num == 1){
        numImage = sq_var.GetAnimationMap("SenseStonenum1", "character/mage/atanimation/als_ani/atoversense/ui/number/1.ani");
    }else if (num == 2){
        numImage = sq_var.GetAnimationMap("SenseStonenum2", "character/mage/atanimation/als_ani/atoversense/ui/number/2.ani");
    }else if (num == 3){
        numImage = sq_var.GetAnimationMap("SenseStonenum3", "character/mage/atanimation/als_ani/atoversense/ui/number/3.ani");
    }else if (num == 4){
        numImage = sq_var.GetAnimationMap("SenseStonenum4", "character/mage/atanimation/als_ani/atoversense/ui/number/4.ani");
    }else if (num == 5){
        numImage = sq_var.GetAnimationMap("SenseStonenum5", "character/mage/atanimation/als_ani/atoversense/ui/number/5.ani");
    }else if (num == 6){
        numImage = sq_var.GetAnimationMap("SenseStonenum6", "character/mage/atanimation/als_ani/atoversense/ui/number/6.ani");
    }else if (num == 7){
        numImage = sq_var.GetAnimationMap("SenseStonenum7", "character/mage/atanimation/als_ani/atoversense/ui/number/7.ani");
    }else if (num == 8){
        numImage = sq_var.GetAnimationMap("SenseStonenum8", "character/mage/atanimation/als_ani/atoversense/ui/number/8.ani");
    }else if (num == 9){
        numImage = sq_var.GetAnimationMap("SenseStonenum9", "character/mage/atanimation/als_ani/atoversense/ui/number/9.ani");
    }

    return numImage;
}


function drawBreakSenseCustomUI(obj)
{
    local skillLevel = sq_GetSkillLevel(obj, SKILL_BREAKSENSE);
    if (skillLevel > 0)
    {
        local x = 124;
        local y = 473;


        local sq_var = obj.getVar();

        local BreakSenseBasicBoard = sq_var.GetAnimationMap("BreakSenseBasicBoard", "character/mage/atanimation/als_ani/atoversense/ui/value.ani");

        local BreakSenseBasicCover = sq_var.GetAnimationMap("BreakSenseBasicCover", "character/mage/atanimation/als_ani/atoversense/ui/value2.ani");

        local BigStarBasicBoard = sq_var.GetAnimationMap("BigStarBasicBoard", "character/mage/atanimation/als_ani/atoversense/ui/star_value.ani");


        local BigStar = sq_var.GetAnimationMap("BigStar", "character/mage/atanimation/als_ani/atoversense/ui/oversense_star.ani");


        local energyBoard = sq_var.GetAnimationMap("energyBoard", "character/mage/atanimation/als_ani/atoversense/ui/enegryboard.ani");


        local BigStarDot = sq_var.GetAnimationMap("bigStarDot", "character/mage/atanimation/als_ani/atoversense/ui/dot.ani");


        local MagicStoneNum0 = null;
        local MagicStoneNum1 = null;



        sq_AnimationProc(BreakSenseBasicBoard);
        sq_drawCurrentFrame(BreakSenseBasicBoard, x, y, false);

//energy ui set

        local apd = obj.GetSquirrelAppendage("character/atmage/breaksense/ap_breaksense.nut");
	if(!apd) return;



        local energy = getBreakSenseEnegry(obj);

//        local maxSth = obj.sq_GetIntData(SKILL_BREAKSENSE, 1);
        local maxEnegry = obj.sq_GetIntData(SKILL_BREAKSENSE, 0);


        local rate = energy % maxEnegry;

        rate = rate.tofloat() / 100.0;

        local magicStone = getBreakSenseMagicStoneCount(obj); //0 1000 > 0 10

        MagicStoneNum0 = getBreakSenseStoneNumberAni(obj,(magicStone / 10).tointeger() );
        MagicStoneNum1 = getBreakSenseStoneNumberAni(obj,(magicStone % 10).tointeger() );

        energyBoard.setImageRate(rate, 1.0);	
        sq_AnimationProc(energyBoard);
        sq_drawCurrentFrame(energyBoard, x + 15, y + 33, false);

//end energy ui set

//increase or decrease
	
        local apState = apd.getVar("state").get_vector(0);
        local energyStateX = x + 14 * (1 - rate) - 1;
        local energyStateY = y - 1;
        if (apState == 1)
        {
            local increaseEnergy = null;//sq_var.GetAnimationMap("increaseEnergy", "character/mage/atanimation/als_ani/atoversense/ui/dot.ani");

            if (magicStone == 0)
            {

                increaseEnergy = sq_var.GetAnimationMap("increaseEnergy1", "character/mage/atanimation/als_ani/atoversense/ui/oversense_increase1.ani");
            }else if (magicStone == 1)
            {

                increaseEnergy = sq_var.GetAnimationMap("increaseEnergy2", "character/mage/atanimation/als_ani/atoversense/ui/oversense_increase2.ani");
            }else if (magicStone >= 2)
            {

                increaseEnergy = sq_var.GetAnimationMap("increaseEnergy3", "character/mage/atanimation/als_ani/atoversense/ui/oversense_increase3.ani");
            }

            increaseEnergy.setImageRate(rate, 1.0);
            sq_AnimationProc(increaseEnergy);
            sq_drawCurrentFrame(increaseEnergy, energyStateX.tointeger(), energyStateY.tointeger(), false);

        }
        else if (apState == 2)
        {

            local decreaseEnergy = null;

            if (magicStone == 0)
            {

                decreaseEnergy = sq_var.GetAnimationMap("decreaseEnergy1", "character/mage/atanimation/als_ani/atoversense/ui/oversense_decrease1.ani");
            }else if (magicStone == 1)
            {

                decreaseEnergy = sq_var.GetAnimationMap("decreaseEnergy2", "character/mage/atanimation/als_ani/atoversense/ui/oversense_decrease2.ani");
            }else if (magicStone >= 2)
            {

                decreaseEnergy = sq_var.GetAnimationMap("decreaseEnergy3", "character/mage/atanimation/als_ani/atoversense/ui/oversense_decrease3.ani");
            }

            decreaseEnergy.setImageRate(rate, 1.0);	
            sq_AnimationProc(decreaseEnergy);
            sq_drawCurrentFrame(decreaseEnergy, energyStateX.tointeger(), energyStateY.tointeger(), false);

        }


//end


        sq_AnimationProc(BreakSenseBasicCover);
        sq_drawCurrentFrame(BreakSenseBasicCover, x, y, false);

        sq_AnimationProc(BigStarBasicBoard);
        sq_drawCurrentFrame(BigStarBasicBoard, x, y, false);

//BigStar MagicStone Ui
        sq_AnimationProc(BigStarDot);
        sq_drawCurrentFrame(BigStarDot, x + 194 , y + 23 , false);

        sq_AnimationProc(MagicStoneNum0);
        sq_drawCurrentFrame(MagicStoneNum0, x - 89 + 290 , y - 488 + 509 , false);

        sq_AnimationProc(MagicStoneNum1);
        sq_drawCurrentFrame(MagicStoneNum1, x - 89 + 298 , y - 488 + 509 , false);


//End BigStar MagicStone Ui

        sq_AnimationProc(BigStar);
        sq_drawCurrentFrame(BigStar, x, y, false);

    }
}

function createAttackInfoBloodCut(obj,damager)
{
	local ani = sq_CreateAnimation("","passiveobject/zrr_skill/atmage/animation/bloodblow_effect.ani");
//    local sizeRate = damager.getObjectHeight().tofloat() / 100.0;
	local pooledObj = sq_CreatePooledObject(ani,true);
	
	pooledObj.setCurrentPos(damager.getXPos(),damager.getYPos() + 1,damager.getZPos() + damager.getObjectHeight()/2 );
	pooledObj.setCurrentDirection(damager.getDirection());
	
	sq_AddObject(obj,pooledObj,0,false);	
}




function checkOverItemObject_ATMage(obj)
{
    //return setOverItemObject(obj);
}

function resetDungeonStart_ATMage(obj, moduleType, resetReason, isDeadTower, isResetSkillUserCount)
{
	if(!obj) return -1;	

    local skillLevel = sq_GetSkillLevel(obj, SKILL_BLOODOATH);
    if (skillLevel > 0)
    {
        bloodValue = obj.sq_GetIntData(SKILL_BLOODOATH, 4);
        obj.sq_AddSetStatePacket(STATE_BLOODOATH, STATE_PRIORITY_USER, true);

        local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_BLOODOATH, false,
         "character/atmage/attack/ap_bloodoath.nut", false);
        local skill_level = sq_GetSkillLevel(obj, SKILL_BLOODOATH);
        appendage.setAppendCauseSkill(BUFF_CAUSE_SKILL, sq_getJob(obj), SKILL_BLOODOATH, skill_level);
        CNSquirrelAppendage.sq_AppendAppendageID(appendage, obj, obj, 129, true);

    }


	local isReset = true; // ????? ?? ?????.
		
	if (sq_GetCurrentModuleType() == MODULE_TYPE_WARROOM || sq_GetCurrentModuleType() == MODULE_TYPE_DEAD_TOWER)
	{
		// ??? ??? ????? ????..
		if (resetReason != REASON_DEATH)
		{
			isReset = false; // ????? ????.
		}
	}
	
	
	if(isReset)
	{ // ??? ?????..
		local appendage = obj.GetSquirrelAppendage("Character/ATMage/IceRoad/ap_ATMage_IceRoad.nut");
		

		if(appendage)
		{
			local skill = sq_GetSkill(obj, SKILL_ICEROAD);
			local isvalid = appendage.isValid();
			
			if(skill)
			{
				print(" isSeal:" + skill.isSealActiveFunction());
				if(!skill.isSealActiveFunction())
				{
					skill.setSealActiveFunction(true);
				}
			}
			
			if(isvalid)
			{
				appendage.setValid(false);
			}
		}
		
		obj.sq_RemoveSkillLoad(SKILL_HOLONG_LIGHT);	// ??? UI ??
	}
	resetDungeonStart_AllGrowJob(obj, moduleType, resetReason, isDeadTower, isResetSkillUserCount);
	return 1;
	
}



function createIceCraftShootEffect(obj,angle)
{
    local ani = sq_CreateAnimation("","passiveobject/zrr_skill/atmage/animation/aticecraft/icecraft_shoot.ani");
	local pooledObj = sq_CreatePooledObject(ani,true);
	pooledObj.setCurrentPos(obj.getXPos() ,obj.getYPos() + 1,obj.getZPos() );
	pooledObj.setCurrentDirection(obj.getDirection());
	sq_AddObject(obj,pooledObj,2,false);	
    sq_SetCustomRotate(pooledObj,angle);


}


function iceCraftHitBehind(obj,damager)
{
    local ani = sq_CreateAnimation("","passiveobject/zrr_skill/atmage/animation/aticecraft/icecraft_hitbehind.ani");
	local pooledObj = sq_CreatePooledObject(ani,true);
	pooledObj.setCurrentPos(damager.getXPos() ,damager.getYPos() - 1,damager.getZPos() + damager.getObjectHeight()/2 );
	pooledObj.setCurrentDirection(damager.getDirection());
	sq_AddObject(obj,pooledObj,2,false);	


}

function iceCraftHitFront(obj,damager)
{
    local ani = sq_CreateAnimation("","passiveobject/zrr_skill/atmage/animation/aticecraft/icecraft_hitfront.ani");
	local pooledObj = sq_CreatePooledObject(ani,true);
	pooledObj.setCurrentPos(damager.getXPos() ,damager.getYPos() + 1,damager.getZPos() + damager.getObjectHeight()/2 );
	pooledObj.setCurrentDirection(damager.getDirection());
	sq_AddObject(obj,pooledObj,2,false);	


}


function sendIcecraft(obj,damager,atk)
{
	local skill_level = sq_GetSkillLevel(obj, SKILL_ICECRAFT);
	if(skill_level > 0)
	{

		local hei = obj.sq_GetIntData(SKILL_ICECRAFT, 2) + sq_getRandom(0,30).tointeger();
		local rate1 = sq_GetLevelData(obj, SKILL_ICECRAFT, 1, skill_level);
		local rate2 = sq_GetLevelData(obj, SKILL_ICECRAFT, 2, skill_level);
		local shootSpeedTime = obj.sq_GetIntData(SKILL_ICECRAFT, 0);
		local size = obj.sq_GetIntData(SKILL_ICECRAFT, 1);
		local posX = obj.getXPos() - damager.getXPos();
		local posY = obj.getYPos() - damager.getYPos();
		local posZ = hei - (damager.getZPos() + damager.getObjectHeight()/2) - 25;

		obj.sq_StartWrite();
		obj.sq_WriteDword(atk );	// attackBonusRate
		obj.sq_WriteDword(2);
		obj.sq_WriteDword(-posX);
		obj.sq_WriteDword(-posY);
		obj.sq_WriteDword(-posZ);
		obj.sq_WriteDword(shootSpeedTime);
		obj.sq_WriteDword(size);
		obj.sq_WriteDword(rate1);
		obj.sq_WriteDword(rate2);
		obj.sq_SendCreatePassiveObjectPacket(24364, 0, -50 - sq_getRandom(0,50).tointeger(), 20, hei);
	}
}

function proc_icecraft(obj)
{
	local skill_level = sq_GetSkillLevel(obj, SKILL_ICECRAFT);
	if(skill_level > 0)
	{

		if (!CNSquirrelAppendage.sq_IsAppendAppendage(obj, "character/atmage/icecraft/ap_icecraft.nut") )
		{
			local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_ICECRAFT , false, "character/atmage/icecraft/ap_icecraft.nut", true);
		}

	}
}

function proc_icemaster(obj)
{
    local skill_level = sq_GetSkillLevel(obj, SKILL_ICEMASTER);
	if(skill_level > 0)
	{

        if (!CNSquirrelAppendage.sq_IsAppendAppendage(obj, "character/atmage/icemaster/ap_icemaster.nut") )
        {
            local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_ICEMASTER , false, 
				"character/atmage/icemaster/ap_icemaster.nut", true);
        }

    }
}




function proc_break(obj)
{
    return false;
    local skill_level = sq_GetSkillLevel(obj, SKILL_BREAK);
	if(skill_level > 0)
	{
        if (!CNSquirrelAppendage.sq_IsAppendAppendage(obj, "character/atmage/break/ap_break.nut") )
        {
            local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_BREAK, false, 
				"character/atmage/break/ap_break.nut", true);

            appendage.setAppendCauseSkill(BUFF_CAUSE_SKILL, sq_getJob(obj), SKILL_BREAK, skill_level);
            CNSquirrelAppendage.sq_AppendAppendageID(appendage, obj, obj, SKILL_BREAK, true);

			local value0 = sq_GetLevelData(obj, SKILL_BREAK, 0, skill_level); 
			local value1 = sq_GetLevelData(obj, SKILL_BREAK, 1, skill_level); 
			local value2 = sq_GetLevelData(obj, SKILL_BREAK, 2, skill_level); 
			local value3 = sq_GetLevelData(obj, SKILL_BREAK, 3, skill_level); 
			local value4 = sq_GetLevelData(obj, SKILL_BREAK, 4, skill_level); 
			local value5 = sq_GetLevelData(obj, SKILL_BREAK, 5, skill_level); 
			local value6 = sq_GetLevelData(obj, SKILL_BREAK, 6, skill_level); 
			local value7 = sq_GetLevelData(obj, SKILL_BREAK, 7, skill_level); 
			local value8 = sq_GetLevelData(obj, SKILL_BREAK, 8, skill_level); 
			local value9 = sq_GetLevelData(obj, SKILL_BREAK, 9, skill_level); 
			local value10 = sq_GetLevelData(obj, SKILL_BREAK, 10, skill_level); 
			local value11 = sq_GetLevelData(obj, SKILL_BREAK, 11, skill_level); 
			local value12 = sq_GetLevelData(obj, SKILL_BREAK, 12, skill_level); 
			local value13 = sq_GetLevelData(obj, SKILL_BREAK, 13, skill_level); 
			local value14 = sq_GetLevelData(obj, SKILL_BREAK, 14, skill_level); 
			local value15 = sq_GetLevelData(obj, SKILL_BREAK, 15, skill_level); 
			local value16 = sq_GetLevelData(obj, SKILL_BREAK, 16, skill_level); 
			local value17 = sq_GetLevelData(obj, SKILL_BREAK, 17, skill_level); 
			local value18 = sq_GetLevelData(obj, SKILL_BREAK, 18, skill_level); 
			local value19 = sq_GetLevelData(obj, SKILL_BREAK, 19, skill_level); 
			local value20 = sq_GetLevelData(obj, SKILL_BREAK, 20, skill_level); 
			local value21 = sq_GetLevelData(obj, SKILL_BREAK, 21, skill_level); 

			local change_appendage = appendage.sq_getChangeStatus("break");

			if(!change_appendage)
            {
				change_appendage = appendage.sq_AddChangeStatusAppendageID(obj, obj, 0, 
				CHANGE_STATUS_TYPE_PHYSICAL_ATTACK, 
				false, value0, APID_COMMON);

			}
            if (change_appendage){
				change_appendage.clearParameter();
				change_appendage.addParameter(CHANGE_STATUS_TYPE_PHYSICAL_ATTACK, false, value0.tofloat());
				change_appendage.addParameter(CHANGE_STATUS_TYPE_MAGICAL_ATTACK, false, value1.tofloat());
				change_appendage.addParameter(CHANGE_STATUS_TYPE_PHYSICAL_DEFENSE, false, value2.tofloat());
				change_appendage.addParameter(CHANGE_STATUS_TYPE_MAGICAL_DEFENSE, false, value3.tofloat());

				change_appendage.addParameter(CHANGE_STATUS_TYPE_EQUIPMENT_PHYSICAL_ATTACK, false, value4.tofloat());
				change_appendage.addParameter(CHANGE_STATUS_TYPE_EQUIPMENT_MAGICAL_ATTACK, false, value5.tofloat());

				change_appendage.addParameter(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_LIGHT, false, value7.tofloat());
				change_appendage.addParameter(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_DARK, false, value8.tofloat());
				change_appendage.addParameter(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_WATER, false, value9.tofloat());
				change_appendage.addParameter(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_FIRE, false, value10.tofloat());

				change_appendage.addParameter(CHANGE_STATUS_TYPE_ELEMENT_TOLERANCE_LIGHT, false, value11.tofloat());
				change_appendage.addParameter(CHANGE_STATUS_TYPE_ELEMENT_TOLERANCE_DARK, false, value12.tofloat());
				change_appendage.addParameter(CHANGE_STATUS_TYPE_ELEMENT_TOLERANCE_WATER, false, value13.tofloat());
				change_appendage.addParameter(CHANGE_STATUS_TYPE_ELEMENT_TOLERANCE_FIRE, false, value14.tofloat());

				change_appendage.addParameter(CHANGE_STATUS_TYPE_PHYSICAL_CRITICAL_HIT_RATE, false, value15.tofloat());
				change_appendage.addParameter(CHANGE_STATUS_TYPE_MAGICAL_CRITICAL_HIT_RATE, false, value16.tofloat());

				change_appendage.addParameter(CHANGE_STATUS_TYPE_STUCK, false, - value17.tofloat());
				change_appendage.addParameter(CHANGE_STATUS_TYPE_BACK_ATTACK_STUCK_TOLERANCE, false, value18.tofloat());

				change_appendage.addParameter(CHANGE_STATUS_TYPE_ATTACK_SPEED, false, value19.tofloat()*10);
				change_appendage.addParameter(CHANGE_STATUS_TYPE_CAST_SPEED, false, value20.tofloat()*10);
				change_appendage.addParameter(CHANGE_STATUS_TYPE_MOVE_SPEED, false, value21.tofloat()*10);

                //pass 6



			}

        }

    }
}

function findLevelTargetMonster(obj)
{
    local target = null;
    target = getBossTarget(obj, -5000, 10000, 2000, 1000, null);
    if (target == null)
    {
        target = getPriorityTarget(obj, -40, 10000, 3000, 1000, null, true);
    }
    return target;
}


function isUpdateAttack(obj)
{
    return CNSquirrelAppendage.sq_IsAppendAppendage(obj, "character/atmage/attack/ap_bloodoath.nut");
}

function addMonsterDeadPassiveObject(obj,damager)
{

    return false;

    local mage = obj.getTopCharacter();
    mage = sq_ObjectToSQRCharacter(mage);	

    if (!CNSquirrelAppendage.sq_IsAppendAppendage(damager, "character/atmage/attack/ap_monsterdeadpassiveobject.nut") && mage.sq_GetSkillLevel(SKILL_BLOODOATH) > 0)
    {
        local masterAppendage = CNSquirrelAppendage.sq_AppendAppendage(damager, mage, SKILL_BLOODHIT, false, "character/atmage/attack/ap_monsterdeadpassiveobject.nut", true);				 
    }


}


function getDashAttackInfo_ATMage(obj)
{
	if (!obj)
		return null;
	
	local attackInfo = obj.sq_GetDashAttackInfo();

    if (obj.sq_GetSkillLevel(SKILL_BLOODOATH) > 0)
    {
		attackInfo = sq_GetCustomAttackInfo(obj,ATTACKINFO_BLOODDASH_ATTACK);
		 sq_SetCurrentAttackInfo(obj,attackInfo);
             obj.applyBasicAttackUp(sq_GetCurrentAttackInfo(obj),15);		
		attackInfo = sq_GetCurrentAttackInfo(obj);
    
    }

	
	local skillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);

    if (skillLevel > 0)
    {
        local skill = sq_GetSkill(obj, SKILL_ICE_ELEMENTAL_ATTACK);
        if (skill.isSealFunction() )
        {
            skillLevel = 0;
        }
    }

	if (skillLevel > 0){
		attackInfo = sq_GetCustomAttackInfo(obj, CUSTOM_ATTACK_INFO_ICE_ELEMENTAL_DASH_ATTACK);
		 sq_SetCurrentAttackInfo(obj,attackInfo);
             obj.applyBasicAttackUp(sq_GetCurrentAttackInfo(obj),15);		
		attackInfo = sq_GetCurrentAttackInfo(obj);
	}
		
	
    if (obj.sq_GetSkillLevel(SKILL_STICKMASTER) > 0)
    {
		attackInfo = sq_GetCustomAttackInfo(obj,ATTACKINFO_WINDDASH);
		 sq_SetCurrentAttackInfo(obj,attackInfo);
             obj.applyBasicAttackUp(sq_GetCurrentAttackInfo(obj),15);		
		attackInfo = sq_GetCurrentAttackInfo(obj);
    }
	return attackInfo;
}


function getJumpAttackInfo_ATMage(obj)
{
	if (!obj)
		return null;	
	
	local attackInfo = obj.sq_GetJumpAttackInfo();

    if (obj.sq_GetSkillLevel(SKILL_BLOODOATH) > 0)
    {
		attackInfo = sq_GetCustomAttackInfo(obj,ATTACKINFO_BLOODJUMP_ATTACK);
 		 sq_SetCurrentAttackInfo(obj,attackInfo);
             obj.applyBasicAttackUp(sq_GetCurrentAttackInfo(obj),7);		
		attackInfo = sq_GetCurrentAttackInfo(obj);
   }

	
	local skillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);

    if (skillLevel > 0)
    {
        local skill = sq_GetSkill(obj, SKILL_ICE_ELEMENTAL_ATTACK);
        if (skill.isSealFunction() )
        {
            skillLevel = 0;
        }
    }

	if (skillLevel > 0){
		attackInfo = sq_GetCustomAttackInfo(obj, CUSTOM_ATTACK_INFO_ICE_ELEMENTAL_JUMP_ATTACK);
		 sq_SetCurrentAttackInfo(obj,attackInfo);
             obj.applyBasicAttackUp(sq_GetCurrentAttackInfo(obj),7);		
		attackInfo = sq_GetCurrentAttackInfo(obj);
	}

	
    if (obj.sq_GetSkillLevel(SKILL_STICKMASTER) > 0)
    {
		attackInfo = sq_GetCustomAttackInfo(obj,ATTACKINFO_WINDJUMP);
		 sq_SetCurrentAttackInfo(obj,attackInfo);
             obj.applyBasicAttackUp(sq_GetCurrentAttackInfo(obj),7);		
		attackInfo = sq_GetCurrentAttackInfo(obj);
    }

	return attackInfo;
}


function getAttackCancelStartFrame_ATMage(obj, index)
{
	if(!obj) return null;
	
	local frm = obj.sq_GetAttackCancelStartFrame(index);
	
    local appendage2 = obj.GetSquirrelAppendage("character/atmage/attack/ap_bloodoath.nut");
    if (appendage2)
    {
        if(index == 0)
        {
            frm = 5;
        }else if(index == 1)
        {
            frm = 6;
        }else if(index == 2)
        {
            frm = 6;
        }
	}
	
	return frm;
}


function getDashAttackAni_ATMage(obj)
{
	if (!obj)
		return null;	
	
	local animation = obj.sq_GetDashAttackAni();

	
	
    if (obj.sq_GetSkillLevel(SKILL_BLOODOATH) > 0)
    {
		animation = obj.sq_GetCustomAni(CUSTOM_ANI_BLOODDASH);
    }


	local skillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);

    if (skillLevel > 0)
    {
        local skill = sq_GetSkill(obj, SKILL_ICE_ELEMENTAL_ATTACK);
        if (skill.isSealFunction() )
        {
            skillLevel = 0;
        }
    }

	if (skillLevel > 0)
		animation = obj.sq_GetCustomAni(CUSTOM_ANI_ICE_ELEMENTAL_DASH_ATTACK);
	

    if (obj.sq_GetSkillLevel(SKILL_STICKMASTER) > 0)
    {
		animation = obj.sq_GetCustomAni(CUSTOM_ANI_WINDDASH);
    }

	return animation;
}






function getJumpAttackAni_ATMage(obj)
{
	if (!obj)
		return null;	
	
	local animation = obj.sq_GetJumpAttackAni();

    if (obj.sq_GetSkillLevel(SKILL_BLOODOATH) > 0)
    {
		animation = obj.sq_GetCustomAni(CUSTOM_ANI_BLOODJUMP);
    }

	
	local skillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);

    if (skillLevel > 0)
    {
        local skill = sq_GetSkill(obj, SKILL_ICE_ELEMENTAL_ATTACK);
        if (skill.isSealFunction() )
        {
            skillLevel = 0;
        }
    }

	if (skillLevel > 0)
		animation = obj.sq_GetCustomAni(CUSTOM_ANI_ICE_ELEMENTAL_JUMP_ATTACK);
	
    if (obj.sq_GetSkillLevel(SKILL_STICKMASTER) > 0)
    {
		animation = obj.sq_GetCustomAni(CUSTOM_ANI_WIND_JUMP_ATK);
    }

	return animation;
}


function getAttackAni_ATMage(obj, index)
{
	if (!obj)
		return null;	
	
	local animation = obj.sq_GetAttackAni(index);

	local skillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);

    if (skillLevel > 0)
    {
        local skill = sq_GetSkill(obj, SKILL_ICE_ELEMENTAL_ATTACK);
        if (skill.isSealFunction() )
        {
            skillLevel = 0;
        }
    }

    if (obj.sq_GetSkillLevel(SKILL_BLOODOATH) > 0)
    {
        animation = obj.sq_GetCustomAni(CUSTOM_ANI_BLOODNORMAL_ATTACK + index);
    }

	if (skillLevel > 0)
    {
            animation = obj.sq_GetCustomAni(CUSTOM_ANI_ICE_ELEMENTAL_ATTACK1 + index);
    }

    if (obj.sq_GetSkillLevel(SKILL_STICKMASTER) > 0)
    {
        animation = obj.sq_GetCustomAni(CUSTOM_ANI_WINDNORMALATTACK + index);
    }


	return animation;
}

function getDefaultAttackInfo_ATMage(obj, index)
{
	if (!obj)
		return null;	
	
	local attackInfo = obj.sq_GetDefaultAttackInfo(index);

	
	local skillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);

    if (skillLevel > 0)
    {
        local skill = sq_GetSkill(obj, SKILL_ICE_ELEMENTAL_ATTACK);
        if (skill.isSealFunction() )
        {
            skillLevel = 0;
        }
    }

	if (skillLevel > 0)
	{
                attackInfo = sq_GetCustomAttackInfo(obj, CUSTOM_ATTACK_INFO_ICE_ELEMENTAL_ATTACK1 + index);
		sq_SetCurrentAttackInfo(obj,attackInfo);
             obj.applyBasicAttackUp(sq_GetCurrentAttackInfo(obj),8);		
		attackInfo = sq_GetCurrentAttackInfo(obj);
	}

    if (obj.sq_GetSkillLevel(SKILL_BLOODOATH) > 0)
    {
                attackInfo = sq_GetCustomAttackInfo(obj, ATTACKINFO_BLOODNORMAL_ATTACK + index);
    		sq_SetCurrentAttackInfo(obj,attackInfo);
             obj.applyBasicAttackUp(sq_GetCurrentAttackInfo(obj),8);		
		attackInfo = sq_GetCurrentAttackInfo(obj);
    }

    if (obj.sq_GetSkillLevel(SKILL_STICKMASTER) > 0)
    {
                attackInfo = sq_GetCustomAttackInfo(obj, ATTACKINFO_WINDNORMALATTACK + index);
             sq_SetCurrentAttackInfo(obj,attackInfo);
             obj.applyBasicAttackUp(sq_GetCurrentAttackInfo(obj),8);		
		attackInfo = sq_GetCurrentAttackInfo(obj);
    }
    		//local datk = sq_GetCurrentAttackInfo(obj);		
		//local attackRate = 1.0+obj.sq_GetBonusRateWithPassive(174, -1, 0, 1.0); 
		//sq_SetCurrentAttackBonusRate(datk, attackRate);
	
	return attackInfo;
}









function onAttack_ATMage(obj, damager, bounding_box, is_stuck)
{
//        addMonsterDeadPassiveObject(obj,damager);
}

function drawBloodMageRedExtandUI(obj)
{
    local skillLevel = sq_GetSkillLevel(obj, SKILL_BLOODOATH);
    if (skillLevel > 0)
    {
        local sq_var = obj.getVar();


        local backEffect = sq_var.GetAnimationMap("BloodMageRedExtandUi_back", 
        "Character/Priest/Effect/Animation/DevilStrike/gauge/4_gaugebar_normal_base.ani");
        sq_AnimationProc(backEffect);
        sq_drawCurrentFrame(backEffect, 700, 580, false);

    }


}

function setBloodValue(obj,value)
{
	if(!obj)
		return;
    if (value > 0)
    {
        if (bloodValue + value > 1000)
        {

            if (obj.sq_GetSkillLevel(SKILL_BLOOD85_PASSIVE) > 0)
            {
                local outBlood = (bloodValue + value - 1000) / 10;
                local outRate = sq_GetLevelData(obj, SKILL_BLOOD85_PASSIVE, 2, sq_GetSkillLevel(obj, SKILL_BLOOD85_PASSIVE) ) ;

                obj.setHp(obj.getHp() + outBlood * outRate, null, true);

            }

            bloodValue = 1000;
            if ( !CNSquirrelAppendage.sq_IsAppendAppendage(obj, "character/atmage/bloodone/ap_bloodone2.nut") )
            {
            

                local skill_level = sq_GetSkillLevel(obj, SKILL_BLOODONE );
                local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_BLOODONE, false, 
                    "character/atmage/bloodone/ap_bloodone.nut", true);
                appendage.setAppendCauseSkill(BUFF_CAUSE_SKILL, sq_getJob(obj), SKILL_BLOODONE, skill_level);

                CNSquirrelAppendage.sq_AppendAppendageID(appendage, obj, obj, SKILL_BLOODONE, true);

                local stuckAdd = sq_GetLevelData(obj, SKILL_BLOODONE, 0, skill_level); 
                local pyAttackRate = sq_GetLevelData(obj, SKILL_BLOODONE, 0, skill_level) / 10; 
                local waitT = obj.sq_GetIntData(SKILL_BLOODONE, 5);
                appendage.sq_SetValidTime(waitT);


                local change_appendage = appendage.sq_getChangeStatus("bloodone");

                if(!change_appendage)
                {
                    change_appendage = appendage.sq_AddChangeStatusAppendageID(obj, obj, 0, 
                    CHANGE_STATUS_TYPE_STUCK, 
                    false, stuckAdd, APID_COMMON);

                }
                if (change_appendage){
                    change_appendage.clearParameter();
                    change_appendage.addParameter(CHANGE_STATUS_TYPE_STUCK, false, -stuckAdd.tofloat());
                    change_appendage.addParameter(CHANGE_STATUS_TYPE_PHYSICAL_ATTACK, false, pyAttackRate.tofloat() );
                }
            }




        }else{
            bloodValue += value;
        }
		
		
    }else{

        local apd = obj.GetSquirrelAppendage("character/atmage/append_bloodmage/ap_bloodmage_gauge.nut");
        if (apd && value < 0)
        {
            local var = apd.getVar("GaugeNum").get_vector(0);
            if (var == -1 || var > bloodValue)
            {
                local currT = apd.getTimer().Get();
                apd.getVar("GaugeNum").set_vector(0,currT);
                apd.getVar("GaugeNum").set_vector(1,bloodValue);
            }
        }

        if (bloodValue + value >= 0)
        {



            if ( CNSquirrelAppendage.sq_IsAppendAppendage(obj, "character/atmage/bloodone/ap_bloodone2.nut") )
            {
                local subRate = obj.sq_GetIntData(SKILL_BLOODONE, 2);
                value = value * (100 - subRate) / 100;

            }

            bloodValue += value;


        }else{


            local BloodToEnergyRate = obj.sq_GetIntData(SKILL_BLOODONE, 4);

            local newBlood = bloodValue + value;
            local lastHp = obj.getHp() + ( (obj.getHpMax() * newBlood) / 1000  ) * BloodToEnergyRate / 100;
            if (lastHp <= 0)
                lastHp = 1;
            obj.setHp(lastHp, null, true);
            bloodValue = 0;


        }
    }
}

function judgeSubBloodValue(obj,value)
{
	if(!obj)
		return;
	if (obj.sq_GetSkillLevel(SKILL_BLOODOATH) <= 0)
		return true;

    //obj.getHp() ??o??e?H??hp
    //obj.getHpMax() ??o?H????jhp
    //obj.setHp(hp, null, true); ?]?w?H??hp
	bloodValue = bloodValue.tointeger();
	value = value.tointeger();
	if (bloodValue - value < 0)
	{
		if (obj.sq_GetSkillLevel(SKILL_BLOODONE) >= 0)
		{

			local BloodToEnergyRate = obj.sq_GetIntData(SKILL_BLOODONE, 4);
			local newBlood = - (bloodValue - value);
			if (obj.getHp() < (obj.getHpMax() * newBlood / 1000) * BloodToEnergyRate / 100 )
			{
				return true;
			}
			else
			{
				return false;
			}

		}
		else
		{
			return true;
		}
	}
	return false;
}


function procSkill_ATMage(obj)
{
	procSkill_BloodOne(obj);
	proc_ParticleVoid(obj);
	procSkill_abyss(obj);
	proc_BreakSense(obj);
	procSkill_IceRoad(obj);
	procSkill_MagicShield(obj);
	return false;
}



function procSkill_abyss(obj)
{		
    local level = sq_GetSkillLevel(obj, SKILL_ABYSS);		
	if(level>0)
	{
		local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_ABYSS, false, 
				"Character/ATMage/Abyss/ap_ATMage_Abyss.nut", true);

		if(!appendage) return;
			
		local skillCondition = obj.sq_GetIntData(SKILL_ABYSS, 1);
		local mpRegenRate = 100 * obj.sq_GetIntData(SKILL_ABYSS, 2); 
		
		if ((obj.getMpMax() * (skillCondition.tofloat()/100)) > obj.getMp())
		{			
			local regen_appendage = appendage.sq_getChangeStatus("abyss_mpregen");
			
			if(!regen_appendage) {
				regen_appendage = appendage.sq_AddChangeStatus("abyss_mpregen",obj, obj, 0, CHANGE_STATUS_TYPE_MP_MAX, true, mpRegenRate);
			}
			
			if(regen_appendage)
			{
				regen_appendage.clearParameter();
				regen_appendage.addParameter(CHANGE_STATUS_TYPE_MP_REGEN_RATE, true, mpRegenRate.tofloat());
			}
		}
	}
}



function getImmuneTypeDamgeRate_ATMage(obj,damageRate, attacker)
{
	

//    sq_SendCreatePassiveObjectPacketPos(obj,12027, 0, attacker.getXPos(), attacker.getYPos() + 1, 0);



	if(obj.getVar("firepillar").size_vector() > 0)
	{
		if(obj.getVar("firepillar").get_vector(VECTOR_FLAG_2))
		{
			if(attacker)
			{
				print( " damageRate:" + damageRate);
				local skillLevel = obj.sq_GetSkillLevel(SKILL_FIREPILLAR);
				local N = obj.sq_GetLevelData(SKILL_FIREPILLAR, 0, skillLevel); 
				
				damageRate = damageRate - N;
				
				print( " convert damageRate:" + damageRate);
			}
		}
	}

	if(CNSquirrelAppendage.sq_IsAppendAppendage(obj, "Character/ATMage/DieHard/ap_ATMage_DieHardSlowHeal.nut")) 
	{
		
		local increaseDamageRate = sq_GetIntData(obj, SKILL_DIEHARD, SKL_STATIC_INT_IDX_0); 
		
		
		damageRate = damageRate + increaseDamageRate;
	}
	
	return damageRate;
}



function getAttackCancelStartFrameSize_ATMage(obj)
{
	local maxAttackNumber = obj.sq_GetAttackCancelStartFrameSize();

	local skillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);
	
    if (skillLevel > 0)
    {
        local skill = sq_GetSkill(obj, SKILL_ICE_ELEMENTAL_ATTACK);
        if (skill.isSealFunction() )
        {
            skillLevel = 0;
        }
    }

	if (skillLevel > 0)
            maxAttackNumber = 2;



    if (obj.sq_GetSkillLevel(SKILL_STICKMASTER) > 0)
    {
        maxAttackNumber = 2;
    }

	return maxAttackNumber;
}



function destroyObject(obj)
{
	local objListSize = obj.getVar().get_obj_vector_size();	
	for(local i =0;i<objListSize;++i)
	{				
		local vObj = obj.getVar().get_obj_vector(i);
		if(vObj == null)
			continue;
			
		vObj.setValid(false);
	}
	
	obj.getVar().clear_obj_vector();
	
}

function destroyObjectByVar(obj, varStr)
{
	local objListSize = obj.getVar(varStr).get_obj_vector_size();	
	for(local i =0;i<objListSize;++i)
	{				
		local vObj = obj.getVar(varStr).get_obj_vector(i);
		if(vObj == null)
			continue;
			
		vObj.setValid(false);
	}
	
	obj.getVar(varStr).clear_obj_vector();
	
}


function getAngle(xPos1, yPos1, xPos2, yPos2)
{
	
	local xDistance = (xPos2 - xPos1);
	local yDistance = (yPos2 - yPos1);

	//print(" xDistance:" + xDistance + " yDistance:" + yDistance);
	
	xDistance = sq_Abs(xDistance);
	yDistance = sq_Abs(yDistance);

	
	local radian = sq_Atan2(yDistance.tofloat(), xDistance.tofloat());
	
	
	local angle = sq_ToDegree(radian);
	
	
	
	//print(" radian:" + radian + " angle:" + angle);
	return (angle + 360) % 360;
}

function getObjectAngle(orgObj, dstObj)
{
	if(!orgObj || !dstObj)
		return 9999.0;
		
	return getAngle(orgObj.getXPos(), orgObj.getYPos(), dstObj.getXPos(), dstObj.getYPos());
}



function isInFrontObject(orgObj, dstObj)
{ 
	if(orgObj.getDirection() == ENUM_DIRECTION_RIGHT)
	{
		if(orgObj.getXPos() < dstObj.getXPos())
			return true;
	}
	else
	{
		if(orgObj.getXPos() > dstObj.getXPos())
			return true;
	}
	
	return false;
}



function findAngleTarget(obj, distance, angle, targetMaxHeight)
{
	if(!obj)
		return null;
		
	local objectManager = obj.getObjectManager();
	

	if (objectManager == null)
		return null;

	local minDistance = 0;
	local target = null;
	

	for (local i = 0; i < objectManager.getCollisionObjectNumber(); i+=1)
	{
		local object = objectManager.getCollisionObject(i);
		if (object && obj.isEnemy(object) && object.isInDamagableState(obj) && object.isObjectType(OBJECTTYPE_ACTIVE) &&
			isInFrontObject(obj, object) && object.getZPos() <= targetMaxHeight)
		{
			local activeObj = sq_GetCNRDObjectToActiveObject(object);
			
			
			if(!activeObj.isDead())
			{
				
				
				print( " angle:" + getObjectAngle(obj, object));
				if(sq_GetDistanceObject(obj, object, false) < distance && getObjectAngle(obj, object) < angle)
				{
					if (target == null || sq_GetDistanceObject(obj, object, false) < minDistance)
					{
						target = activeObj;
						minDistance = sq_GetDistanceObject(obj, object, false);
					}
				}
			}
		}
	}

	return target;
}


function findAngleTargetWithParticleVoid(obj, distance, angle, targetMaxHeight)
{
	if(!obj)
		return null;
	local objectManager = obj.getObjectManager();
	if (objectManager == null)
		return null;
	local minDistance = 0;
	local target = null;
	for (local i = 0; i < objectManager.getCollisionObjectNumber(); i+=1)
	{
		local object = objectManager.getCollisionObject(i);
		if (object && obj.isEnemy(object) && object.isInDamagableState(obj) && object.isObjectType(OBJECTTYPE_ACTIVE) && isInFrontObject(obj, object))
		{
			local activeObj = sq_GetCNRDObjectToActiveObject(object);
			if(!activeObj.isDead())
			{
				if(CNSquirrelAppendage.sq_IsAppendAppendage(activeObj, "character/atmage/particlevoid/ap_particle_void_to_enemy.nut"))
				{
					return activeObj;
				}
				if(activeObj.getZPos() > targetMaxHeight)
					return null;
				if(sq_GetDistanceObject(obj, object, false) < distance && getObjectAngle(obj, object) < angle)
				{
					if (target == null || sq_GetDistanceObject(obj, object, false) < minDistance)
					{
						target = activeObj;
						minDistance = sq_GetDistanceObject(obj, object, false);
					}
				}
			}
		}
	}
	return target;
}



function isSameObjectBySqVar(orgObj, sq_var)
{
	if(!orgObj || !sq_var)
		return false;
	
	local i;
	local object_num = sq_var.get_obj_vector_size();
	
	for(i = 0; i < object_num; i++)
	{ 
		local dstObj = sq_var.get_obj_vector(i);
		
		local isSame = isSameObject(orgObj, dstObj);
		
		if(isSame) 
			return true;
	}
	
	return false;
	
}

function getBossTarget(obj, firstTargetXStartRange, firstTargetXEndRange, firstTargetYRange, targetMaxHeight, exceptSqVar)
{
	if(!obj)
		return null;
		
	local objectManager = obj.getObjectManager();
	

	if (objectManager == null)
		return null;

	
	local target = null;
	

	for (local i = 0; i < objectManager.getCollisionObjectNumber(); i+=1)
	{
		local object = objectManager.getCollisionObject(i);
		if (object && obj.isEnemy(object) && object.isInDamagableState(obj) && object.isObjectType(OBJECTTYPE_ACTIVE) &&
			isInFrontObject(obj, object) && object.getZPos() <= targetMaxHeight )
		{
			if(sq_IsinMapArea(obj, object, firstTargetXStartRange, firstTargetXEndRange, firstTargetYRange))
			{
				local activeObj = sq_GetCNRDObjectToActiveObject(object);
				
				if(!activeObj.isDead())
				{ 
					if(activeObj.isBoss())
					{ 
						local isExist = isSameObjectBySqVar(object, exceptSqVar);
						
						if(!isExist || target == null)
						{
							target = activeObj;
						}
					}
				}
			}
		}
	}

	return target;

}

function getPriorityTarget(obj, firstTargetXStartRange, firstTargetXEndRange, firstTargetYRange, targetMaxHeight, exceptSqVar, isInFront)
{
	if(!obj)
		return null;
		
	local objectManager = obj.getObjectManager();
	

	if (objectManager == null)
		return null;

	
	local target = null;
	

	for (local i = 0; i < objectManager.getCollisionObjectNumber(); i+=1)
	{
		local object = objectManager.getCollisionObject(i);
		if (object && obj.isEnemy(object) && object.isInDamagableState(obj) && object.isObjectType(OBJECTTYPE_ACTIVE) &&
			object.getZPos() <= targetMaxHeight )
		{
			if(isInFront == true)
			{
				if(isInFrontObject(obj, object) == false)
				{
					continue;
				}
			}
			if(sq_IsinMapArea(obj, object, firstTargetXStartRange, firstTargetXEndRange, firstTargetYRange))
			{
				local activeObj = sq_GetCNRDObjectToActiveObject(object);
				
				if(!activeObj.isDead())
				{ 
					local isExist = isSameObjectBySqVar(object, exceptSqVar);
					
					if(activeObj.isBoss())
					{
						if(target == null)
						{
							target = activeObj;
							
							if(!isExist)
								return target;
						}
					}
					
					if(activeObj.isSuperChampion())
					{ 
						if(target == null || !isExist)
						{
							target = activeObj;
							
							if(!isExist)
								return target;
						}
					}
					
					if(activeObj.isCommonChampion())
					{
						if(target == null || !isExist)
						{
							target = activeObj;
							
							if(!isExist)
								return target;
						}
					}
					
					if(activeObj.isChampion())
					{
						if(target == null || !isExist)
						{
							target = activeObj;
							
							if(!isExist)
								return target;
						}
					}
					
					if(target == null || !isExist)
					{
						target = activeObj;
						
						if(!isExist)
							return target;
					}
				}
			}
		}
	}

	return target;

}



function createPaticleMap(obj, filename, x, y, z)
{
	local particleCreater = obj.getVar().GetparticleCreaterMap(filename, filename, obj);
		
	particleCreater.Restart(0);
	particleCreater.SetPos(x, y, z);
	sq_AddParticleObject(obj, particleCreater);
}

function initGetVarTimer(obj, maxTimerNum, eventTerm, eventMaxCount)
{
	if(maxTimerNum <= 0)
		return;
		
	local sq_var = obj.getVar();
	
	sq_var.clear_timer_vector();
	
	for (local i = 0;i < maxTimerNum; i+=1)
	{
		sq_var.push_timer_vector();
	}
	
	for (local i = 0;i < maxTimerNum; i+=1)
	{
		local t = sq_var.get_timer_vector(i);
		t.setParameter(eventTerm, eventMaxCount);
		t.resetInstant(i);
	}

}


function procParticleCreaterMap(obj, currentT, filename, x, y, z)
{
	local t = obj.getVar().get_timer_vector(0);
	
	if(!t)
		return;
	
	if(t.isOnEvent(currentT) == true)
	{
		local particleCreater = obj.getVar().GetparticleCreaterMap(filename, filename, obj);
			
		particleCreater.Restart(0);
		particleCreater.SetPos(x, y, z);	
		
		sq_AddParticleObject(obj, particleCreater);
	}
}


function createAnimationPooledObject(obj, aniFilename, isAutoDestroy, x, y, z)
{
	local ani = sq_CreateAnimation("",aniFilename);
	local pooledObj = sq_CreatePooledObject(ani,isAutoDestroy);
	
	pooledObj.setCurrentPos(x,y,z);
	sq_SetCurrentDirection(pooledObj, obj.getDirection());
	
	sq_AddObject(obj, pooledObj, OBJECTTYPE_DRAWONLY, false);
	
	return pooledObj;
}

function createAnimationImageRatePooledObject(obj, aniFilename, isAutoDestroy, widthRate, heightRate, x, y, z)
{
	local ani = sq_CreateAnimation("",aniFilename);
	
	if(!ani)
		return null;
	
	ani.setImageRateFromOriginal(widthRate, heightRate);
	
	local pooledObj = sq_CreatePooledObject(ani,isAutoDestroy);
	
	pooledObj.setCurrentPos(x,y,z);
	sq_SetCurrentDirection(pooledObj, obj.getDirection());
	
	sq_AddObject(obj, pooledObj, OBJECTTYPE_DRAWONLY, false);
	
	return pooledObj;
}





function playMoveSound_ATMage(obj)
{
	
	
	if(!obj)
		return;
	
	local result = CNSquirrelAppendage.sq_IsAppendAppendage(obj, "Character/ATMage/IceRoad/ap_ATMage_IceRoad.nut");

	if (result == true) 
	{
		obj.sq_PlaySound("R_ICE_WALK_LOOP", SOUND_ID_MOVE);
	}
	else 
	{
		obj.sq_PlayMoveSound();
	}
}

function procDash_ATMage(obj)
{
	if(!obj)
		return;
	
	local ani = sq_GetCurrentAnimation(obj);
	
	if(!ani)
		return;
		
	local isFlag = obj.sq_IsKeyFrameFlag(ani, 1);
	
	
	local result = CNSquirrelAppendage.sq_IsAppendAppendage(obj, "Character/ATMage/IceRoad/ap_ATMage_IceRoad.nut");

	if (result == true) 
	{
		
		if(isFlag)
		{
			obj.sq_PlaySound("R_ICE_WALK");
		}
		
		obj.sq_ClearKeyFrameFlag(ani);
	}
	else
	{
		
		
		if (isFlag)
		{
			local stage = sq_GetGlobaludpModuleStage();
			if(!stage)
				return;
			
			local dungeon = sq_GetDungeonByStage(stage);
			
			if(!dungeon)
				return;
				
			local dungeonIndex = sq_GetDuegonIndex(dungeon);			
			local mapIndex = sq_GetMapIndex(stage);

			
			if (dungeonIndex == 40 || mapIndex == 50019)
			{
				obj.sq_PlaySound("R_RUN_SNOW");
			}
			else
			{
				local weight = sq_GetObjectWeight(obj);
				if (sq_GetShadowTypeByAnimation() != 0)
					obj.sq_PlaySound("R_RUN_FLOOR");
				else if (weight < LIGHT_OBJECT_MAX_WEIGHT)
					obj.sq_PlaySound("RUN_STONE");
				else if (weight < MIDDLE_OBJECT_MAX_WEIGHT)
					obj.sq_PlaySound("RUN_SOIL");
				else
					obj.sq_PlaySound("RUN_GRASS");
			}
		}
		obj.sq_ClearKeyFrameFlag(ani);
		
	}
}





function procSkill_MagicShield(obj)
{
}



function getImmuneType_ATMage(obj,type, attacker)	
{
	local immuneType = type;
	
	return immuneType;
}





function useSkill_before_ATMage(obj, skillIndex, consumeMp, consumeItem, oldSkillMpRate)
{	
	local bChangedMp = false;
	
	//print(" consumpMp:" + consumeMp + " oldSkillMpRate:" + oldSkillMpRate);
	
	local appendage = obj.GetSquirrelAppendage("Character/ATMage/ManaBurst/ap_ATMage_ManaBurst.nut");
	
	if(appendage)
	{
		local isvalid = appendage.isValid();
		
		if(isvalid)
		{
			local skillLevel = obj.sq_GetSkillLevel(SKILL_MANABURST);
			local mpComsumeRate = sq_GetLevelData(obj, SKILL_MANABURST, SKL_LVL_COLUMN_IDX_0, skillLevel);
			local newMpRate = oldSkillMpRate.tofloat() * (100 + mpComsumeRate.tofloat()) / 100;
			
			print(" newMpRate:" + newMpRate);
			obj.setSkillMpRate(skillIndex, newMpRate.tofloat());
			bChangedMp = true;
		}		
	}
	
	if(obj.sq_GetSkillLevel(SKILL_EXPRESSION) > 0)
	{
		local skillLevel = obj.sq_GetSkillLevel(SKILL_EXPRESSION);
		local skillMpRate = obj.getSkillMpRate(skillIndex);
		local mpComsumeRate = sq_GetLevelData(obj, SKILL_EXPRESSION, 0, skillLevel);
		local newMpRate = skillMpRate.tofloat() * (100 - mpComsumeRate.tofloat()) / 100;
		
		
		
		

		obj.setSkillMpRate(skillIndex, newMpRate.tofloat());
	}
	
	//print(" now consumpMp:" + obj.getSkillMpRate(skillIndex));

	if(!sq_IsMyCharacter(obj) || sq_isPVPMode()) return true;

	if(skillIndex == 28 || skillIndex == 31|| skillIndex == 97|| skillIndex == 142|| skillIndex == 158)
	{
		if(isEnableDrawCutscene(obj,skillIndex))
			drawATMageBuffUI(obj,skillIndex);
	}else if(skillIndex == 49 || skillIndex == 48|| skillIndex == 109|| skillIndex == 103|| skillIndex == 126)
	{
		if(isEnableDrawCutscene(obj,skillIndex))
			ULTIMATE_SKILL_ID = skillIndex;

	}else if(skillIndex == 245 || skillIndex == 248|| skillIndex == 95|| skillIndex == 121|| skillIndex == 124)
	{
		if(isEnableDrawCutscene(obj,skillIndex))
			AWAKE_SKILL_ID = skillIndex;
	}
	
	return true;
}



function useSkill_after_ATMage(obj, skillIndex, consumeMp, consumeItem, oldSkillMpRate)
{
	if(!obj)
		return false;
	obj.setSkillMpRate(skillIndex, oldSkillMpRate.tofloat());
	//print(" after set consumpMp:" + oldSkillMpRate);
	return true;
}


function setState_ATMage(obj, state, datas, isResetTimer)
{
    setState_Gunner(obj, state, datas, isResetTimer);
	if(state == STATE_DIE)
		obj.sq_RemoveSkillLoad(SKILL_HOLONG_LIGHT);	
	return 0;
}



function setEnableCancelSkill_ATMage(obj, isEnable)
{
	if(!obj)
		return false;
	
	if(!obj.isMyControlObject())
		return false;


	if(!isEnable)
		return true;
		
	
	
	
	local GROW_TYPE_AT_MAGE = 0; 
	local GROW_TYPE_ELEMENTAL_BOMBER = 1; 
	local GROW_TYPE_GLACIALMASTER = 2; 
	
	
	
	
	
	
	
	{	

		obj.setSkillCommandEnable(SKILL_WIND_STRIKE, isEnable);

		obj.setSkillCommandEnable(SKILL_PUSH_OUT, isEnable);

		obj.setSkillCommandEnable(SKILL_FALLENBLOSSOMS, isEnable);

		obj.setSkillCommandEnable(SKILL_TURNWINDMILL, isEnable);

		obj.setSkillCommandEnable(SKILL_BROKENARROW, isEnable);

		obj.setSkillCommandEnable(SKILL_ICE_CRASH, isEnable);

		obj.setSkillCommandEnable(SKILL_FROZENLAND, isEnable);

		obj.setSkillCommandEnable(SKILL_ICE_SWORD, isEnable);

		obj.setSkillCommandEnable(SKILL_MULTI_SHOT, isEnable);

		obj.setSkillCommandEnable(SKILL_FLAMECIRCLE, isEnable);

		
		


		obj.setSkillCommandEnable(SKILL_ICE_ORB_EX, isEnable);


		obj.setSkillCommandEnable(SKILL_CONCENTRATE_EX, isEnable);



		obj.setSkillCommandEnable(SKILL_ELEMENTAL_STRIKE_EX, isEnable);

		obj.setSkillCommandEnable(SKILL_ICE_FIELD_EX, isEnable);
		
		
		if(sq_getGrowType(obj) == GROW_TYPE_GLACIALMASTER)
		{	
			obj.setSkillCommandEnable(SKILL_ICE_SWORD, isEnable);
		}
	}
	
	
	
	
	
	
	return true;
	
	local size = 10; 
	local cancel_skill_l =[];
	local skill_l =[];
	cancel_skill_l.resize(size);
	skill_l.resize(size);










	cancel_skill_l[0] = SKILL_CANCEL_WIND_STRIKE;
	cancel_skill_l[1] = SKILL_CANCEL_PUSH_OUT;
	cancel_skill_l[2] = SKILL_CANCEL_FALLENBLOSSOMS;
	cancel_skill_l[3] = SKILL_CANCEL_TURNWINDMILL;
	cancel_skill_l[4] = SKILL_CANCEL_BROKENARROW;
	cancel_skill_l[5] = SKILL_CANCEL_ICE_CRASH;
	cancel_skill_l[6] = SKILL_CANCEL_FROZENLAND;
	cancel_skill_l[7] = SKILL_CANCEL_ICE_SWORD;
	cancel_skill_l[8] = SKILL_CANCEL_FLAMECIRCLE;
	cancel_skill_l[9] = SKILL_CANCEL_MULTI_SHOT;

	skill_l[0] = SKILL_WIND_STRIKE;
	skill_l[1] = SKILL_PUSH_OUT;
	skill_l[2] = SKILL_FALLENBLOSSOMS;
	skill_l[3] = SKILL_TURNWINDMILL;
	skill_l[4] = SKILL_BROKENARROW;
	skill_l[5] = SKILL_ICE_CRASH;
	skill_l[6] = SKILL_FROZENLAND;
	skill_l[7] = SKILL_ICE_SWORD;
	skill_l[8] = SKILL_FLAMECIRCLE;
	skill_l[9] = SKILL_MULTI_SHOT;

	for(local i=0;i<size;i+=1)
	{
		
		local level = sq_GetSkillLevel(obj, cancel_skill_l[i]);
		local bRet = false;
		
		if(level > 0)
		{
			if(isEnable)
			{
				bRet = true;
			}
		}
		
		obj.setSkillCommandEnable(skill_l[i], bRet);
	}
	
	
	return true;
}

function sendSetHpPacket_ATMage(obj, hp, sendInstant)
{
	if(CNSquirrelAppendage.sq_IsAppendAppendage(obj, "Character/ATMage/DieHard/ap_ATMage_DieHardSlowHeal.nut")) 
	{
		if(obj.getHp() < hp)
		{
			
			return false;
		}
	}
	
	return true;
}

function sendSetMpPacket_ATMage(obj, mp, sendInstant)
{	
	return true;
}





function isApplyConversionSkillPassiveObject_ATMage(passiveObjectIndex)
{
	if (passiveObjectIndex == 24201)
	{	
		return true;
	}
	else if (passiveObjectIndex == 24222)
	{	
		return true;
	}
	else if (passiveObjectIndex == 12004)
	{	
		return true;
}
	else if (passiveObjectIndex == 24217)
	{	
		return true;
	}
	else if (passiveObjectIndex == 24254)
	{	
		return true;
	}
    else if (passiveObjectIndex == 24357)
    {
        return true;
    }
	
	
	
	local idx = passiveObjectIndex;
	if (idx >= 24266 && idx <= 24283)
	{
		return true;
	}
	
	return false;
}







function addElementalChain_ATMage(obj, element)
{
	if (!obj) return;
	if (element == ENUM_ELEMENT_MAX) return;
	local skillLevel = sq_GetSkillLevel(obj, SKILL_ELEMENTAL_CHAIN);
	if (skillLevel <= 0) return;
	
	local skill = sq_GetSkill(obj, SKILL_ELEMENTAL_CHAIN);
	if (!skill) return;
	local changeValue = obj.sq_GetLevelData(SKILL_ELEMENTAL_CHAIN, 0, skillLevel);
	local validTime = obj.sq_GetLevelData(SKILL_ELEMENTAL_CHAIN, 1, skillLevel);
	
	local apFire = null;
	local apWater = null;
	local apDark = null;
	local apLight = null;
	
	if (element == ENUM_ELEMENT_FIRE)
	{
		apWater = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_WATER, false, changeValue.tofloat(), validTime);
		apDark = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_DARK, false, changeValue.tofloat(), validTime);
		apLight = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_LIGHT, false, changeValue.tofloat(), validTime);
	}
	else if (element == ENUM_ELEMENT_WATER)
	{
		apFire = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_FIRE, false, changeValue.tofloat(), validTime);
		apDark = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_DARK, false, changeValue.tofloat(), validTime);
		apLight = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_LIGHT, false, changeValue.tofloat(), validTime);
	}
	else if (element == ENUM_ELEMENT_DARK)
	{
		apFire = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_FIRE, false, changeValue.tofloat(), validTime);
		apWater = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_WATER, false, changeValue.tofloat(), validTime);
		apLight = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_LIGHT, false, changeValue.tofloat(), validTime);
	}
	else if (element == ENUM_ELEMENT_LIGHT)
	{
		apFire = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_FIRE, false, changeValue.tofloat(), validTime);
		apWater = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_WATER, false, changeValue.tofloat(), validTime);
		apDark = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_DARK, false, changeValue.tofloat(), validTime);
	}
	else if (element == -1)
	{
		apFire = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_FIRE, false, changeValue.tofloat(), validTime);
		apWater = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_WATER, false, changeValue.tofloat(), validTime);
		apDark = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_DARK, false, changeValue.tofloat(), validTime);
		apLight = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_LIGHT, false, changeValue.tofloat(), validTime);
	}
	
	if (apFire != null)
		apFire.sq_Append(obj, obj, APID_SKILL_ELEMENTAL_CHAIN_FIRE);
	if (apWater != null)
		apWater.sq_Append(obj, obj, APID_SKILL_ELEMENTAL_CHAIN_WATER);
	if (apDark != null)
		apDark.sq_Append(obj, obj, APID_SKILL_ELEMENTAL_CHAIN_DARK);
	if (apLight != null)
		apLight.sq_Append(obj, obj, APID_SKILL_ELEMENTAL_CHAIN_LIGHT);
}



function changeTrhowState_ATMage(obj, throwState)
{
	if (!obj) return false;
	
	printc("changeTrhowState_ATMage");
	if (throwState == 3 &&
		obj.getThrowIndex() == SKILL_ELEMENTAL_CHANGE)
	{
		
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(throwState);
		obj.sq_IntVectPush(-1);
		obj.sq_IntVectPush(obj.getThrowElement());
		obj.sq_AddSetStatePacket(STATE_THROW, STATE_PRIORITY_USER, true);
		return true;
	}

	return false;
}

function isCounterState_ATMage(obj, isCounter)
{
	if(obj.getVar("firepillar").size_vector() > 0)
	{
		if(obj.getVar("firepillar").get_vector(VECTOR_FLAG_2))
		{
			isCounter = false;
		}
	}
	
	return isCounter;
}


function AppendAppendageToSimple(obj, skillIndex, appendageFileName, validTime, isBuff)
{
	local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, skillIndex, false, appendageFileName, false);
	
	appendage.sq_SetValidTime(validTime); 
	
	
	CNSquirrelAppendage.sq_Append(appendage, obj, obj, isBuff); 

}

function setActiveStatus_ATMage(obj, activeStatus, power)
{
	if (!obj) return 0;
	
	local state = sq_GetState(obj);
	
	if (state == STATE_ELEMENTAL_BUSTER)
	{
		
		
		return 0;
	}
	
	return 1;
}


function reset_ATMage(obj)
{
	if(!obj)
		return;		
	
}







function procSkill_IceRoad(obj)
{
	local appendage = obj.GetSquirrelAppendage("Character/ATMage/IceRoad/ap_ATMage_IceRoad.nut");
	
	if(appendage) {
		local isvalid = appendage.isValid();
		if(isvalid) {
			local currentT = appendage.getTimer().Get();
			local t = appendage.sq_var.get_timer_vector(0);
			local t2 = appendage.sq_var.get_timer_vector(1); // ????? ????? ??? ????? ?????? ???? mp??? ????.
			
			if (t2.isOnEvent(currentT) == true)
			{
				local skill = sq_GetSkill(obj, SKILL_ICEROAD);
				if(skill)
				{
					local skill_level = obj.sq_GetSkillLevel(SKILL_ICEROAD);
					local spendMp = obj.sq_GetLevelData(SKILL_ICEROAD, SKL_LV_0, skill_level); // 0.???MP ???
					if (spendMp > obj.getMp())
					{
						appendage.setValid(false);
						skill.setSealActiveFunction(true);
						return;
					}
					else
					{
						// MP? ????? ??? ? ???? ???..
						print( " spendMp:" + spendMp);
						obj.sendSetMpPacket(obj.getMp() - spendMp);
					}
				
				}
			}
			
			if (t.getEventTerm() == -1)
				return;
			
			if (t.isOnEvent(currentT) == true)
			{
				if(obj.isMyControlObject())
				{
					if(obj.getZPos() == 0)
					{
						local skill_level = sq_GetSkillLevel(obj, SKILL_ICEROAD);
						local change_time = sq_GetLevelData(obj, SKILL_ICEROAD, SKL_LV_1, skill_level); // ????
						local rate = sq_GetLevelData(obj, SKILL_ICEROAD, SKL_LV_3, skill_level); // ?? ??
						local movSpd = sq_GetLevelData(obj, SKILL_ICEROAD, SKL_LV_2, skill_level); // 
					
						sq_BinaryStartWrite();
						sq_BinaryWriteDword(change_time);	// ??
						sq_BinaryWriteDword(rate);			// ??
						sq_BinaryWriteDword(movSpd);		// ??? 
						
						// ??? ?? ?? ??? ??? ???? ?? ?? ?? ????? ???.
						local skillLevel = sq_GetSkillLevel(obj, SKILL_ICEROAD_EX);
						sq_BinaryWriteWord(skillLevel);
						
						if (skillLevel > 0)
						{
							local prob = sq_GetLevelData(obj, SKILL_ICEROAD_EX, 4, skillLevel) / 10.0;// ???? ??? ??
							local asLevel = sq_GetLevelData(obj, SKILL_ICEROAD_EX, 5, skillLevel);	// ???? ??? ??
							local validTime = sq_GetLevelData(obj, SKILL_ICEROAD_EX, 6, skillLevel);	// ???? ??? ??
							sq_BinaryWriteFloat(prob.tofloat());	// ??
							sq_BinaryWriteWord(asLevel);			// ??
							sq_BinaryWriteDword(validTime);			// ??
						}
						
						sq_SendCreatePassiveObjectPacket(obj, 24243, 0, 0, 0, 0, obj.getDirection());
					}
				}
			}
		}
	}	
}


function onChangeSkillEffect_ATMageNew(obj, skillIndex, reciveData)
{
	if(!obj)
		return;
		
//    sq_SendCreatePassiveObjectPacketPos(obj,12027, 0,obj.getXPos(), obj.getYPos() + 1, 0);
	if(skillIndex == SKILL_ICEROAD)
	{
		local skill = sq_GetSkill(obj, SKILL_ICEROAD);
		skill.resetCurrentCoolTime();
		skill.setSealActiveFunction(true);	
		local skill_level = sq_GetSkillLevel(obj, SKILL_ICEROAD);
		obj.startSkillCoolTime(SKILL_ICEROAD, skill_level, -1);
		
		local appendage = obj.GetSquirrelAppendage("Character/ATMage/IceRoad/ap_ATMage_IceRoad.nut");
		appendage.setValid(false);
	}
	else if(skillIndex == SKILL_DIEHARD)
	{
		if(reciveData.getSize() > 0)
		{
			local hp = reciveData.readDword(); 
			if(hp > 0)
			{
				print(" onchange:" + hp);
				obj.setHp(hp, null, true);
			}
		}
	}
	else if (skillIndex == SKILL_ELEMENTAL_CHANGE)
	{
		if (reciveData.getSize() > 0)
		{
			local element = reciveData.readByte();
			obj.setThrowElement(element);
			local appendage = CNSquirrelAppendage.sq_GetAppendage(obj,"Character/ATMage/MagicShield/ap_MagicShield.nut");
			if(appendage)
				setMagicShieldType(appendage, obj, obj.getThrowElement());	
		}
	}
	else if(skillIndex == SKILL_TUNDRASOUL)
	{
		if (reciveData.getSize() > 0)
		{
			local mode = reciveData.readDword();
			local auraAppendage = 0;
			local appendage = CNSquirrelAppendage.sq_GetAppendage(obj, "Character/ATMage/TundraSoul/ap_ATMage_TundraSoul.nut");
			if(appendage)
			{
				auraAppendage = appendage.sq_getSquirrelAuraMaster("AuraTundraSoul");
				if(mode == 1)			
				{ 
					appendage.sq_DeleteAppendages();
				}
				else if(mode == 0)
				{ 
					local range = obj.sq_GetIntData(SKILL_TUNDRASOUL , 0);
					appendage.sq_AddSquirrelAuraMaster("AuraTundraSoul",obj, obj, range, 18, 5, 0);
				}
			}
		
		}
	}
}




function onstartBloodMageAppendage(appendage)
{
	local sourceObj = appendage.getSource();
	local parentObj = appendage.getParent();

	parentObj = sq_GetCNRDObjectToActiveObject(parentObj);
	sourceObj = sq_GetCNRDObjectToSQRCharacter(sourceObj);
	if(!sourceObj || !parentObj ) 
    {
		appendage.setValid(false);
		return;
	}


    if (parentObj.getHp() <= 0)
    {
		appendage.setValid(false);
		return;
    }
	gal_addMonsterActiveStatusEffect(parentObj,8,15);
    appendage.getVar("flag").clear_vector();
    appendage.getVar("flag").push_vector(0);
    appendage.getVar("time").clear_vector();
    appendage.getVar("time").push_vector(0);
}

function onEndBloodMageAppendage(appendage)
{

	local sourceObj = appendage.getSource();
	sourceObj = sq_GetCNRDObjectToSQRCharacter(sourceObj);

	local parentObj = appendage.getParent();
	parentObj = sq_GetCNRDObjectToActiveObject(parentObj);

    if (sourceObj)
        createBloodOathSoabrotEffect(sourceObj);

	gal_addMonsterActiveStatusEffect(parentObj,8,-1);

}


function onProcBloodMageAppendage(appendage,last_count)
{


    local parentObj = appendage.getParent();
	local sourceObj = appendage.getSource();

	sourceObj = sq_GetCNRDObjectToSQRCharacter(sourceObj);
	parentObj = sq_GetCNRDObjectToActiveObject(parentObj);

    local count = appendage.getVar("count").get_vector(0);
    local curT = appendage.getTimer().Get();

	if(!sourceObj || !parentObj ) 
    {

		appendage.setValid(false);
		return;
	}

    local time = appendage.getVar("time").get_vector(0);
    if (curT - time >= 500)
    {
        appendage.getVar("time").set_vector(0,curT);
        local apd = sourceObj.GetSquirrelAppendage("character/atmage/append_bloodmage/ap_bloodmage_gauge.nut");
        local id = -1;
        for (local i = 0;i< 25 ;i++)
        {
            if (apd.getVar("EnergyParameter").get_vector(i * 3) == -1)
            {
                id = i;
                break;
            }
        }

        if (id != -1)
        {

            local curT = apd.getTimer().Get();
            apd.getVar("EnergyParameter").set_vector(3 * id + 0,curT);
            apd.getVar("EnergyParameter").set_vector(3 * id + 1,parentObj.getXPos() * 100 + sq_getRandom(0,50).tointeger() );
            apd.getVar("EnergyParameter").set_vector(3 * id + 2,parentObj.getYPos() * 1000 + parentObj.getZPos()
            + parentObj.getObjectHeight()/2);
        }


    }


    if (curT > last_count * 500)
    {

		appendage.setValid(false);
		return;

    }

    if (!parentObj.isBoss() && parentObj.isDead() )
    {

        if (!CNSquirrelAppendage.sq_IsAppendAppendage(parentObj, "character/atmage/append_bloodmage/ap_dieeffect.nut") )
        {
            local masterAppendage = CNSquirrelAppendage.sq_AppendAppendage(parentObj, sourceObj, SKILL_BLOODOATH, false, 
            "character/atmage/append_bloodmage/ap_dieeffect.nut", true);				 
            if(masterAppendage) 
            {
                sq_HoldAndDelayDie(parentObj, sourceObj, true, false, false, 200, 200, ENUM_DIRECTION_NEUTRAL , masterAppendage);
            }
        }

    }

}

function sq_setCurrentPosInMoveAble(obj,x,y,z,isSet)
{

    if (z > 0)
        sq_setCurrentAxisPos(obj, 2, z);
    else
        sq_setCurrentAxisPos(obj, 2, 0);

    if (!sq_IsMovablePosCollisionObject(obj,x,y) )
    {

        if (isSet == true)
        {

            local posX = obj.sq_findNearLinearMovableXPos(x, y,obj.getXPos(), obj.getYPos(), 10);
            sq_setCurrentAxisPos(obj, 0, posX);
            return true;

        }else
        {

            return false;

        }

    }else
    {

        if ( sq_IsMovablePosCollisionObject(obj,x,obj.getYPos() ) )
            sq_setCurrentAxisPos(obj, 0, x);
        if ( sq_IsMovablePosCollisionObject(obj,obj.getXPos(),y ) )
            sq_setCurrentAxisPos(obj, 1, y);

        return true;

    }

    return false;
}

function procAppend_ATMage(obj)
{
	if(!obj) return 0;

	if(sq_isPVPMode()) return;
		if ( !CNSquirrelAppendage.sq_IsAppendAppendage ( obj, "character/atmage/currency.nut" ) ) //????
		{
		local appendage1 = CNSquirrelAppendage.sq_AppendAppendage ( obj, obj, 174, false, "character/atmage/currency.nut", true );
		}

}

function sq_getCurrentCharacterAppendTime(obj)
{
	local apd = getComboUiAppendage(obj);
	if (apd)
		return apd.getTimer().Get();
	
	return -1;

}

function getComboUiAppendage ( obj )
{
	return obj.GetSquirrelAppendage ( "character/atmage/currency.nut" );
}


function sq_GetSkillCurrentCoolTime(obj,skillIndex)
{
	if (skillIndex < 0)
        return 0;

	local skl = sq_GetSkill(obj,skillIndex);
	if (skl)
	{
		local apd = getComboUiAppendage(obj);
		if (!apd)
			return false;
		
		local currentT = apd.getTimer().Get();
		local coolTime = apd.getVar("saveCurrentSklTime").get_vector(skillIndex);
		local curCoolTime = coolTime - (currentT - apd.getVar("saveSkillOkTime").get_vector(skillIndex));
		return curCoolTime;
	}
	return 0;
}

function createUIAniWithIDPath(obj,id,path)
{
    obj = sq_GetCNRDObjectToSQRCharacter(obj);
    local sq_var = obj.getVar();
    GLOBAL_SKILL_AWAKENING_ANI_ID = id;
    local ani = sq_var.GetAnimationMap("skillAwakeningID_" + id, path );
    ani.setCurrentFrameWithChildLayer(0);


}


function drawSirocoUINumberWithPos ( obj, x, y, var )
{

	if ( var == 0 )
	{
		local ani = getSirocoUINumber ( obj, 0 );
		sq_AnimationProc ( ani );
		sq_drawCurrentFrame ( ani, x, y, false );
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
}

function drawBloodMageUI(obj) {
	if(!obj) return;
	if (sq_getJob(obj) == 8 && sq_GetSkillLevel(obj, SKILL_BLOODOATH) > 0) {
        local x = 193;
        local y = 524;
		local xclip = CFG_UI_BLOODMAGEGAUGE_CLIP_OFFSETX;
		local height = CFG_UI_BLOODMAGEGAUGE_HEIGHT;

		local sq_var = obj.getVar();
		local bloodMageBackGround = sq_var.GetAnimationMap("bloodMageBackGround", "common/newstylecomboui/bloodmage/hud.ani");
		setClip(x, y, x + xclip, y + height);
		sq_AnimationProc(bloodMageBackGround);
		sq_drawCurrentFrame(bloodMageBackGround, x, y - 2, false);
		releaseClip();
		
		local bloodMageGauge = sq_var.GetAnimationMap("bloodMageGauge", "common/newstylecomboui/bloodmage/front.ani");
		setClip(x - 100, y + (height - (height.tofloat() * bloodValue.tofloat() / 1000.0).tointeger()), x + xclip, y + height);
		sq_AnimationProc(bloodMageGauge);
		sq_drawCurrentFrame(bloodMageGauge, x + 4, y, false);
		releaseClip();
		
		if (!CNSquirrelAppendage.sq_IsAppendAppendage(obj, "character/atmage/append_bloodmage/ap_bloodmage_gauge.nut")) {
			local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_BLOODONE, false, "character/atmage/append_bloodmage/ap_bloodmage_gauge.nut", true);
		}
		local apd = obj.GetSquirrelAppendage("character/atmage/append_bloodmage/ap_bloodmage_gauge.nut");
		if (!apd)
			return false;
		local t = apd.getVar("GaugeNum").get_vector(0);
		if (t != -1) {
			local saveGauge = apd.getVar("GaugeNum").get_vector(1);
			local currT = apd.getTimer().Get();
			if (currT - t >= 500) {
				apd.getVar("GaugeNum").set_vector(0, -1);
				apd.getVar("GaugeNum").set_vector(1, -1);
			} else {
				local currentT = currT - t;
				local bloodMageGauge = sq_var.GetAnimationMap("bloodMageGaugeWhileAni", "common/newstylecomboui/bloodmage/while.ani");
				setClip(x, y + (height - (height.tofloat() * saveGauge.tofloat() / 1000.0).tointeger()), x + xclip, y + (height - (height.tofloat() * bloodValue.tofloat() / 1000.0).tointeger()));
				sq_AnimationProc(bloodMageGauge);
				sq_drawCurrentFrame(bloodMageGauge, x + 4, y);
				releaseClip();
			}
		}
		local gaugeFrame = sq_var.GetAnimationMap("gaugeFrameAni", "common/newstylecomboui/bloodmage/frame.ani");
		sq_DrawSpecificFrame(gaugeFrame, CFG_UI_BLOODMAGEGAUGEFRAME_POS_X, CFG_UI_BLOODMAGEGAUGEFRAME_POS_Y, false, 0, false, 1.0);
		if(CFG_FUNC_BLOODMAGEGAUGE_NUM < 1){
			return true;
		}
		drawSirocoUINumberWithPos(obj, x + 20, y + height/3, bloodValue / 10);
	}
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
