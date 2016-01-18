xquery version "3.0";

declare namespace xes='http://www.xes-standard.org/';

import module namespace mba  = 'http://www.dke.jku.at/MBA' at 'C:/Users/manue/Masterarbeit/Analysis/MBAse/mba.xqm';
import module namespace functx = 'http://www.functx.com' at 'C:/Users/manue/Masterarbeit/Analysis/MBAse/functx.xqm';
import module namespace analysis='http://www.dke.jku.at/MBA/Analysis' at 'C:/Users/manue/Masterarbeit/Analysis/analysis.xqm';

import module namespace sc='http://www.w3.org/2005/07/scxml' at 'C:/Users/manue/Masterarbeit/Analysis/MBAse/scxml.xqm';

let $testData := fn:doc("C:/Users/manue/Masterarbeit/Analysis/Data/TestData.xml")

let $mba := $testData/mba:mba
let $mbaTactCar := $testData//mba:mba[@name="MyCarInsuranceCompany"]
let $mbaTactHouse := $testData//mba:mba[@name="MyHouseholdInsuranceCompany"]

let $mbaOptCarClerk := $testData//mba:mba[@name="MyCarInsuranceClerk"]

(:return sc:computeEntrySet($mbaOptCarClerk//sc:transition[@event="finishedCollecting"]):)

(:return analysis:averageCycleTime($mba, "tacticalInsurance", "End1", "ChooseProducts"):) (:15M:)

(:return analysis:getStateLog($mbaOptCarClerk):)

(:return analysis:getCycleTimeOfInstance($mbaTactCar, ():) (:40M:)

(:return analysis:getTotalActualCycleTime($mba, "tacticalInsurance", "End1"):)(:1H5M:)

(:return analysis:getTotalCycleTimeInStates($mbaTactCar, "tacticalInsurance", ("ChooseProducts", "CheckFeasibility")):) (:15M:)

(:return analysis:getCreationTime($mba):)

(: checks if the creation time of a mba is between 5:30 and 8:00 :)
let $timeFunc := function($mba as element()
) as xs:boolean {
    let $from := functx:time(5,30,0)
    let $until := functx:time(8,0,0)

    let $creationTime := functx:time(
            fn:hours-from-dateTime(analysis:getCreationTime($mba)),
            fn:minutes-from-dateTime(analysis:getCreationTime($mba)),
            fn:seconds-from-dateTime(analysis:getCreationTime($mba))
    )

    return
        if ($creationTime > $from and
            $creationTime < $until) then
                fn:true()
        else
            fn:false()
}

(:return analysis:getActualAverageLambda($mba, 'operationalInsurance', $timeFunc):)

(: return mba:getAncestors($mbaOptCarClerk):) (: Cannot promote node()* to element(). :)
(: return mba:getAncestors($mbaTactCar) :) (: works fine! but why? :)

return analysis:getTransitionProbability($mba,
        'tacticalInsurance',
        'CheckFeasibility',
        'End1',
        ()
)

(: When $eventState is 'ImplementProduct', it works. But 'DevelopProducts' fails --> only on output!
   Exception in thread "main" javax.xml.xquery.XQException:
   XQJFOS021 - FORWARD_ONLY_SEQUENCE: Cursor is not positioned on an XQItem.
   :)

(:let $entrySet := sc:computeEntrySet($transition)
let $config := sc:getSourceState($transition)/ancestor-or-self::sc:state
let $exitSet := sc:computeExitSet($config, $transition)
:)