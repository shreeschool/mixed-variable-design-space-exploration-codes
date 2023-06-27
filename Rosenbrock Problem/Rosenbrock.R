setwd("D:/IIT Madras/Gifi methods/Final Unconstrained problems/Rosenbrock 2D")
# D:/IIT Madras/Gifi methods/Final Unconstrained problems/Rosenbrock 2D
library(readxl)
data=read_excel('ros_exp5.xlsx')

##Homals on mixed data

x1<-data[,c('x1')]
x1<-as.numeric(unlist(x1))
x2<-data[,c('x2')]
x2<-as.numeric(unlist(x2))
x3<-data[,c('y')]
x3<-as.numeric(unlist(x3))
# x4<-data[,c('PetalWidthCm')]
# x4<-as.numeric(unlist(x4))
# x5<-data[,c('Species')]
# x5<-as.numeric(unlist(x5))
# x6<-data[,c('children')]
# x6<-as.numeric(unlist(x6))
# x7<-data[,c('wife ed')]
# x7<-as.numeric(unlist(x7))
# x8<-data[,c('huband ed')]
# x8<-as.numeric(unlist(x8))
# x9<-data[,c('husband oc')]
# x9<-as.numeric(unlist(x9))
# x10<-data[,c('standard')]
# x10<-as.numeric(unlist(x10))
M_mixed1<-data.frame(x1,x2,x3)
#M_mixed<-data.frame(M_mixed = unlist(M_mixed))
M_mixed1<- na.omit(
  object=M_mixed1
)
##Define the spline knots
item_knots<-Gifi::knotsGifi(
  x=M_mixed1[,c('x1','x3')],
  type='Q',n=4
) ##item knots(data)
species_knots<- Gifi::knotsGifi(
  x=M_mixed1[,'x2'],
  type='D'
) ##method knots(data)
# wifeed_knots <- Gifi::knotsGifi(
#   x=M_mixed1[,'x7'],
#   type='Q'
# ) ##libcons knots(data)
# husbanded_knots <- Gifi::knotsGifi(
#   x=M_mixed1[,'x8'],
#   type='Q'
# ) ##libcons knots(data)
# husbandoc_knots <- Gifi::knotsGifi(
#   x=M_mixed1[,'x9'],
#   type='Q'
# ) ##libcons knots(data)
# standard_knots<-Gifi::knotsGifi(
#   x=M_mixed1[,'x10'],
#   type='Q'
# )## lleftright terciles
# 
# age_knots<-Gifi::knotsGifi(
#   x=M_mixed1[,'x5'],
#   type='Q'
# )## age knots (empty)
# children_knots<-Gifi::knotsGifi(
#   x=M_mixed1[,'x6'],
#   type='Q'
# )## age knots (empty)

list_knots<-c(
  item_knots,species_knots
)


##Fit the mixed homal models
V_ordinal<- c(
  rep(TRUE,3)
) #decides nature of the data input
V_degree<-c(
  rep(-1,1),rep(1,2)
) ##decides degree of the transformation
copvec<-c(rep(1,3))
#for mixed data with princals
# homal_mixed<-Gifi::homals(
#   M_mixed1,
#   knots=list_knots,
#   ordinal=V_ordinal,
#   degrees = V_degree,
# )## fitting the transformation
# plot(
#   x=homal_mixed,
#   plot.type='transplot',
#   var.subset=1:10
# )##plot on the graphs
princals_mixed_iris<-Gifi::princals(
  M_mixed1,
  knots=list_knots,
  ordinal=V_ordinal,
  degrees = V_degree,
  copies=copvec,
  missing = "a"
)## fitting the transformation
plot(
  x=princals_mixed_iris,
  plot.type='transplot',
  var.subset=1:3
)##plot on the graphs
# plot(x=princals_mixed, plot.type = "biplot",asp=10)
# plot(homal_mixed, "screeplot")
library("writexl")
write_xlsx(data.frame(princals_mixed_iris[["scoremat"]]),"D:/IIT Madras/Gifi methods/Final Unconstrained problems/Rosenbrock 2D/conversion_ros_exp5.xlsx")