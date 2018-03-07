

add(A1,A2,S):- S is (A1+A2).

/*
Question 1
*/

once([],M):- M=[].
once([H|T],M):-member(H,T),delete(T,H,NT),once(NT,M).
once([H|T],[H|M]):-not(member(H,T)),once(T,M).


/*
Question 2
*/


pairsElem(E,[],X,Ac,Ac).
pairsElem(E,[H|T],X,Ac,M):-add(E,H,S),S=:=X,add(Ac,1,NAc),pairsElem(E,T,X,NAc,M).
pairsElem(E,[H|T],X,Ac,M):-pairsElem(E,T,X,Ac,M).

pairs(L,X,M):-pairs(L,X,0,M).

pairs([],X,Ac,Ac).
pairs([H|T],X,Ac,M):-pairsElem(H,T,X,0,M1),add(Ac,M1,NM1),pairs(T,X,NM1,M).


/*
Question 3
*/

willItChange(I,[],Ac,Ac).
willItChange(I,[(Fav,Hat)|T],Ac,YN):-(I is Hat),add(Ac,1,NAc),willItChange(I,[],NAc,YN).
willItChange(I,[(Fav,Hat)|T],Ac,YN):-not(I is Hat),willItChange(I,T,0,YN).

dragForever(M,M,L,C):- willItChange(M,L,1,YN),not(YN is 0),(C is -1). %Terminal_case1
dragForever(M,I,L,C):-willItChange(I,L,1,YN),(YN is 0),(C is 0). %Terminal_case2
dragForever(M,I,L,C):-willItChange(I,L,1,YN),not(YN is 0),add(I,1,NI),dragForever(M,NI,L,C).


howManyHappy(N,I,[],Ac,Ac).
howManyHappy(N,I,[(Fav,Hat)|T],Ac,H):- (I is Hat),howManyHappy(N,I,T,Ac,H).
howManyHappy(N,I,[(Fav,Hat)|T],Ac,H):- not(I is Hat),add(Ac,1,NAc),howManyHappy(N,I,T,NAc,H).


changeChannel(I,[(Fav,Hat)|T],NI):-(I is Hat),(NI is Fav).
changeChannel(I,[(Fav,Hat)|T],NI):-not(I is Hat),changeChannel(I,T,NI).


allHappy(N,M,I,L,C):-dragForever(M,1,L,YN),(YN is -1),(C is -1).
allHappy(N,M,I,L,C):-allHappy(N,M,I,L,C,0).

allHappy(N,M,I,L,C,Ac):-howManyHappy(N,I,L,0,H),H=:=N,(C is Ac).
allHappy(N,M,I,L,C,Ac):-howManyHappy(N,I,L,0,H),changeChannel(I,L,NI),add(Ac,1,NAc),allHappy(N,M,NI,L,C,NAc).


/*
Question 5
maxDiff(L,M,D):-makeNewList(L,M,Ac,NL),makeListOfDifs(NL,[],LD),getMaxElem(LD,0,Max),(Max=<0),(D is Max).
*/


getHead([H|T],H).
getTail([H|T],T).
getASpeed((D,AS),AS).

setAcR(T,SpeedG,L,M):-append(L,[SpeedG],NL),append([NL],[T],M).
setAcCon(SpeedG,L,T,Ac):-append(L,[SpeedG],NL),append([T],[NL],Ac).

makeElem((Dist,Speed),[[(DistG,SpeedG)|T],L],M):-(Dist=:=DistG),setAcR(T,SpeedG,L,M).
makeElem((Dist,Speed),[[(DistG,SpeedG)|T],L],M):-(Dist<DistG),add(DistG,-Dist,NDistG),append([(NDistG,SpeedG)],T,NT),setAcR(NT,SpeedG,L,M).
makeElem((Dist,Speed),[[(DistG,SpeedG)|T],L],M):-(Dist>DistG),add(Dist,-DistG,NDist),setAcCon(SpeedG,L,T,Ac),makeElem((NDist,Speed),Ac,M).


makeNewList([],G,Ac,Ac).
makeNewList([H|T],G,Ac,M):-makeElem(H,[G,[]],R),getHead(R,DS),append([H],DS,Map),append(Ac,[Map],NAc),nth0(1,R,NG),makeNewList(T,NG,NAc,M).


getMaxElem([],Temp,Temp).
getMaxElem([H|T],Temp,Max):-(H>Temp),getMaxElem(T,H,Max).
getMaxElem([H|T],Temp,Max):-(H=<Temp),getMaxElem(T,Temp,Max).


makeListOfDifs([],Ac,Ac).
makeListOfDifs([H|T],[],LD):-getTail(H,TH),getMaxElem(TH,0,Max),nth0(0,H,Tup),getASpeed(Tup,AS),add(Max,-AS,Diff),makeListOfDifs(T,[Diff],LD).
makeListOfDifs([H|T],Ac,LD):-getTail(H,TH),getMaxElem(TH,0,Max),nth0(0,H,Tup),getASpeed(Tup,AS),add(Max,-AS,Diff),append(Ac,[Diff],NAc),makeListOfDifs(T,NAc,LD).


maxDiff(L,M,D):-makeNewList(L,M,Ac,NL),makeListOfDifs(NL,[],LD),getMaxElem(LD,0,Max),(D is Max).


/*
Question 4
*/



addFoods((P1,T1),[],Ac,Ac).
addFoods((P1,T1),[(P2,F,T2)|T],Ac,M):-not(P1=:=P2),addFoods((P1,T1),T,Ac,M).
addFoods((P1,T1),[(P2,F,T2)|T],Ac,M):-(P1=:=P2),not(T2<T1),addFoods((P1,T1),[],Ac,M).
addFoods((P1,T1),[(P2,F,T2)|T],Ac,M):-(P1=:=P2),(T2<T1),append(Ac,[F],NAc),addFoods((P1,T1),T,NAc,M).


makeFoodList([],L,Ac,Ac).
makeFoodList([H|T],L,Ac,FL):-addFoods(H,L,[],Fs),append(Ac,Fs,NAc),makeFoodList(T,L,NAc,FL).


eraseDuplicates([],Ac,Ac).
eraseDuplicates([H|T],Ac,DF):-member(H,T),delete(T,H,NT),append(Ac,[H],NAc),eraseDuplicates(NT,NAc,DF).
eraseDuplicates([H|T],Ac,DF):-not(member(H,T)),append(Ac,[H],NAc),eraseDuplicates(T,NAc,DF).

souloupList(L,SL):-eraseDuplicates(L,[],SL).

doctorWho(BF,[],Ac,Ac).
doctorWho(BF,[(P,F,Ti)|T],Ac,Pi):-member(F,BF),append(Ac,[P],NAc),doctorWho(BF,T,NAc,Pi).
doctorWho(BF,[(P,F,Ti)|T],Ac,Pi):-not(member(F,BF)),doctorWho(BF,T,Ac,Pi).

countElems([],Num,Num).
countElems([H|T],Ac,Num):-add(Ac,1,NAc),countElems(T,NAc,Num).


doses(N,M,L,W,D):-makeFoodList(W,L,[],FL),souloupList(FL,Sfl),doctorWho(Sfl,L,[],Pi),souloupList(Pi,Spi),countElems(Spi,0,D).













































