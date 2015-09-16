# add all the packages we need
require(twitteR)
require(plyr)

# ADD STUFF

install.packages(c("devtools", "rjson", "bit64", "httr"))

#RESTART R session!

library(devtools)
install_github("twitteR", username = "geoffjentry")
library(twitteR)

# add addition tools (this should mitigate the changes Twitter made to thier API summer 2015)
if (!require("pacman")) install.packages("pacman")
pacman::p_load(twitteR, sentiment, plyr, ggplot2, wordcloud, RColorBrewer, httpuv, RCurl, base64enc)

options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

# SIGN IN. You'll need your own api key and secret and acccess token and secret. 

api_key <- "YOU WILL NEED YOUR OWN"
api_secret <- "YOU WILL NEED YOUR OWN"
access_token <- "YOU WILL NEED YOUR OWN"
access_token_secret <- "YOU WILL NEED YOUR OWN"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

# now let's MAKE IT HAPPEN
# I started with some exploritory data looking at things I'd noticed before. 

# go awn
goAwn<-searchTwitter('"go awn"',n=1000)
goAwn.df = do.call("rbind",lapply(goAwn,as.data.frame))
head(goAwn.df)

# go on
goOn<-searchTwitter('"go on"',n=1000)
goOn.df = do.call("rbind",lapply(goOn,as.data.frame))
head(goOn.df)

# go awf
goAwf<-searchTwitter('"go awf"',n=1000)
goAwf.df = do.call("rbind",lapply(goAwf,as.data.frame))
head(goAwf.df)

# go off
goOff<-searchTwitter('"go off"',n=1000)
goOff.df = do.call("rbind",lapply(goOff,as.data.frame))
head(goOff.df)

# and all together
allData <- rbind(goOff.df, goAwf.df, goOn.df, goAwn.df)
write.csv(allData, "allDataAwfOffAwnOn.csv")

# Then I looked for certain regions to see if that would be helpful. 
# Mostly I learned that people stright-up don't use geotags.

# now for looking at region these geocodes and population estimates were 
# generated using http://www.freemaptools.com/ citation: Andreas, V. (n.d.). 
# Radius Around Point. Retrieved February 1, 2015. The map may be viewed here: 
# http://maps.google.com/maps/api/staticmap?size=600x500&path=fillcolor:0x00FF00|weight:1|color:0xFFFFFF|enc:ay|lHhrprT~bCs_{ChjKggzCtoSwvxCzq[invCpoc@cnsCtgk@}voCxxr@aikCxaz@kefCtaaAql`CfwgAs_zBnanAo_sBh_tAgmkB|oyAejcBnr~AkwzA`fcBivqA`jgBihhAv}jB{n~@r`nBskt@drpB_`j@`rrBum_@|_tBgvTn{tBm{ItduB?n{tBl{I|_tBfvT`rrBtm_@drpB~_j@r`nBrkt@v}jBzn~@`jgBhhhA`fcBhvqAnr~AjwzA|oyAdjcBh_tAfmkBnanAn_sBfwgAr_zBtaaApl`Cxaz@jefCxxr@`ikCtgk@|voCpoc@bnsCzq[hnvCtoSvvxChjKfgzC~bCr_{C_cCr_{CijKhgzCuoSvvxC{q[fnvCqoc@dnsCugk@zvoCyxr@`ikCyaz@jefCuaaArl`CgwgAr_zBoanAn_sBi_tAfmkB}oyAbjcBor~AjwzAafcBhvqAajgBhhhAw}jB|n~@s`nBrkt@erpB~_j@arrBrm_@}_tBfvTo{tBn{IuduB?o{tBo{I}_tBgvTarrBsm_@erpB_`j@s`nBskt@w}jB}n~@ajgBihhAafcBivqAor~AkwzA}oyAcjcBi_tAgmkBoanAo_sBgwgAs_zBuaaAsl`Cyaz@kefCyxr@aikCugk@{voCqoc@ensC{q[gnvCuoSwvxCijKigzC_cCs_{C&path=fillcolor:0x00FF00|weight:1|color:0xFFFFFF|enc:mngmFtjreO~kAabrAreFcuqAb~Jg{pAvtOstoAxhTmanAnyX}alAdf]mviAdna@e_gAvpe@y|cAhmi@so`Ahcm@gx|@brp@gwx@bys@gmt@|wv@}zo@`ny@}`k@b{{@c`f@p~}@ey`@fx_A_m[zgaAk|U`mbAehPzgcAgqJ|wcAsxDh}cA?|wcArxDzgcAfqJbmbAdhPxgaAj|Uhx_A~l[p~}@dy`@`{{@b`f@`ny@|`k@|wv@|zo@bys@fmt@brp@fwx@hcm@fx|@jmi@ro`Avpe@x|cAbna@d_gAdf]lviAnyX|alAxhTlanAvtOrtoAb~Jf{pAreFbuqA~kA`brA_lA~arAseFbuqAc~Jf{pAwtOrtoAyhTlanAoyX|alAef]lviAcna@d_gAwpe@x|cAkmi@ro`Aicm@fx|@crp@fwx@cys@fmt@}wv@|zo@any@|`k@a{{@b`f@q~}@dy`@ix_A~l[ygaAj|UcmbAdhP{gcAhqJ}wcApxDi}cA?}wcAqxD{gcAiqJambAehP{gaAk|Ugx_A_m[q~}@ey`@c{{@c`f@any@}`k@}wv@}zo@cys@gmt@crp@gwx@icm@gx|@imi@so`Awpe@y|cAena@e_gAef]mviAoyX}alAyhTmanAwtOstoAc~Jg{pAseFcuqA_lA_brA&sensor=true
# west: 41.991670,-113.303568,965 (the radius is in km) the estimated population
# is around 59,939,200 south: 33.97980872872457,-84.96826171875,563 the 
# estimated population is around 39,673,370
geocodeWest = "40.799700,-113.303568,965km"
geocodeSouthEast = "33.979808,-84.968261,563km"

# go awn west
goAwnWest<-searchTwitter('"go awn"',n=1000, geocode = geocodeWest)
goAwnWest.df = do.call("rbind",lapply(goAwnWest,as.data.frame))
head(goAwnWest.df)

# go on west
goOnWest<-searchTwitter('"go on"',n=1000, geocode = geocodeWest)
goOnWest.df = do.call("rbind",lapply(goOnWest,as.data.frame))
head(goOnWest.df)

# go awn south
goAwnsouth<-searchTwitter('"go awn"',n=1000, geocode = geocodeSouthEast)
goAwnsouth.df = do.call("rbind",lapply(goAwnsouth,as.data.frame))
head(goAwnsouth.df)

# go on south
goOnsouth<-searchTwitter('"go on"',n=1000, geocode = geocodeSouthEast)
goOnsouth.df = do.call("rbind",lapply(goOnsouth,as.data.frame))
head(goOnsouth.df)

# go awf south
goAwfsouth<-searchTwitter('"go awf"',n=1000, geocode = geocodeSouthEast)
goAwfsouth.df = do.call("rbind",lapply(goAwfsouth,as.data.frame))
head(goAwfsouth.df)

# go awf west
goAwfWest<-searchTwitter('"go awf"',n=1000, geocode = geocodeWest)
goAwfWest.df = do.call("rbind",lapply(goAwfWest,as.data.frame))
head(goAwfWest.df)

# Then I decided to use frequent open-o words so that I was sampling in a principaled way. 

# the most frequent 100 English words that contain AO (open o), accoring to the CMU pronuncing dictionary:
# for
# on
# or
# all
# your
# also 
# want
# because 

# search all varient spellings from CMU pronuncing dictionary 
words <- c("awn", "awr", "awll", "yawr", "awlso", "wawnt", "becawse")
TwitterData <- NULL
for(i in 1:length(words)){
  word <- searchTwitter(words[i], n=100, lang = "en")
  word.df = do.call("rbind",lapply(word,as.data.frame))
  TwitterData <- rbind(TwitterData, word.df)
}
  
write.csv(TwitterData, "TwitterData.csv")
