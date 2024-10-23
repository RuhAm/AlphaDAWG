#!/usr/bin/perl -w
use strict;

my $MIN_REP = $ARGV[0];
my $MAX_REP = $ARGV[1];


my $n = 200;
my $L = 1.1e6;
my $N = 1e4;
my $mu = 1.25e-8;
my $meanR = 1e-8;
my $theta = 4 * $N * $mu * $L;
my $meanRho = 4 * $N * $meanR * $L;


my $infreq_lower_log10 = log(0.001) / log(10);
my $infreq_upper_log10 = log(0.1) / log(10);
my $mutsel_lower_log10 = log(2 * $N * 0.005) / log(10);
my $mutsel_upper_log10 = log(2 * $N * 0.5) / log(10);
my $selend_lower = 0.0;
my $selend_upper = 1200 / (4 * $N);


for(my $i = $MIN_REP; $i <= $MAX_REP; $i++) {
	my $infreq = 10**( rand( $infreq_upper_log10 - $infreq_lower_log10 ) + $infreq_lower_log10 );
	my $mutsel = 10**( rand( $mutsel_upper_log10 - $mutsel_lower_log10 ) + $mutsel_lower_log10 );
	my $selend = rand( $selend_upper - $selend_lower ) + $selend_lower;
	
	my $line = sprintf("./discoal %d 1 %d -t %lf -Pre %lf %lf -ws %lf -a %lf -x 0.5 -f %lf -en 0.000825 0 35.6990250217 -en 0.000858912361906 0 35.5962827189 -en 0.000930976381034 0 34.8175656386 -en 0.000969244996741 0 34.1755473032 -en 0.00100908667808 0 33.3908206734 -en 0.00105056608732 0 32.4839664807 -en 0.00109375054472 0 31.4758281652 -en 0.00113871013783 0 30.3869586773 -en 0.00118551783516 0 29.2371521817 -en 0.0012342496047 0 28.045066281 -en 0.00128498453716 0 26.8279351959 -en 0.00133780497433 0 25.601370095 -en 0.00139279664275 0 24.3792395305 -en 0.00145004879283 0 23.1736206999 -en 0.00150965434366 0 21.994810945 -en 0.00157171003391 0 20.8513883871 -en 0.00163631657874 0 19.7502753884 -en 0.0017035788333 0 18.695726298 -en 0.00177360596291 0 17.6895169707 -en 0.00184651162024 0 16.7326743585 -en 0.00192241412973 0 15.8256589161 -en 0.00200143667967 0 14.9684422422 -en 0.00216936018102 0 13.4012874565 -en 0.00225853366897 0 12.6894922714 -en 0.0023513727128 0 12.0239054153 -en 0.00244802798846 0 11.4030688128 -en 0.00254865636555 0 10.8254044795 -en 0.00265342116197 0 10.2892570693 -en 0.00276249240891 0 9.79293128325 -en 0.0028760471269 0 9.3347245021 -en 0.00299426961299 0 8.91295506251 -en 0.00324549326772 0 8.17189891208 -en 0.00337890216743 0 7.84667475204 -en 0.00351779495913 0 7.54590052007 -en 0.00366239706309 0 7.26570130819 -en 0.00381294316569 0 7.00266462117 -en 0.00396967760031 0 6.75377702756 -en 0.00413285474386 0 6.51637390878 -en 0.00430273942966 0 6.2881000312 -en 0.00447960737721 0 6.06687906053 -en 0.00466374563972 0 5.85089043371 -en 0.00485545306999 0 5.63855222204 -en 0.00505504080541 0 5.42850877898 -en 0.00526283277298 0 5.21962208082 -en 0.00547916621498 0 5.01096575158 -en 0.00570439223634 0 4.80182082572 -en 0.0059388763745 0 4.59167235321 -en 0.00618299919259 0 4.38021383148 -en 0.00643715689718 0 4.16823518928 -en 0.00670176198123 0 3.95819376356 -en 0.00697724389362 0 3.75237494201 -en 0.00726404973608 0 3.55268054594 -en 0.00756264498887 0 3.36064976155 -en 0.00787351426624 0 3.17748805214 -en 0.00819716210294 0 3.00410139254 -en 0.00853411377304 0 2.84113353516 -en 0.0088849161425 0 2.68900442408 -en 0.00925013855672 0 2.54794828642 -en 0.00963037376448 0 2.41805032466 -en 0.0100262388802 0 2.29928129339 -en 0.0104383763849 0 2.19152956029 -en 0.01086745517 0 2.09463052198 -en 0.0113141716218 0 2.00839347229 -en 0.0117792507523 0 1.93262621001 -en 0.012263447376 0 1.86709181667 -en 0.0127675473343 0 1.81085961455 -en 0.0132923687717 0 1.76267633914 -en 0.0138387634631 0 1.72145041331 -en 0.0144076181963 0 1.68622714923 -en 0.0149998562115 0 1.65616164358 -en 0.0156164386992 0 1.63049667958 -en 0.0162583663609 0 1.60854469921 -en 0.0169266810324 0 1.58967313394 -en 0.0176224673754 0 1.57329255609 -en 0.0183468546377 0 1.55884724814 -en 0.0191010184853 0 1.54580789098 -en 0.0198861829116 0 1.53366615161 -en 0.0207036222228 0 1.52193100933 -en 0.0215546631072 0 1.51012670071 -en 0.0224406867873 0 1.49779218885 -en 0.0233631312622 0 1.48448214453 -en 0.0243234936411 0 1.46992225853 -en 0.0253233325734 0 1.45432552405 -en 0.0263642707782 0 1.43799083202 -en 0.0274479976776 0 1.42120654337 -en 0.0285762721392 0 1.40424934162 -en 0.0297509253303 0 1.38738363716 -en 0.0309738636902 0 1.37086148564 -en 0.0322470720236 0 1.35492298136 -en 0.0335726167229 0 1.33979708706 -en 0.034952649121 0 1.32570286478 -en 0.0363894089835 0 1.31285107733 -en 0.0378852281435 0 1.30144613734 -en 0.0394425342862 0 1.29168838869 -en 0.0410638548889 0 1.28377671612 -en 0.0427518213231 0 1.27791148989 -en 0.0445091731254 0 1.2742978661 -en 0.0463387624432 0 1.27314240278 -en 0.0482435586641 0 1.27450131346 -en 0.0502266532351 0 1.278282334 -en 0.0522912646797 0 1.28439907877 -en 0.054440743822 0 1.29277631409 -en 0.0566785792243 0 1.30334831256 -en 0.0590084028497 0 1.31605734024 -en 0.0614339959564 0 1.33085225132 -en 0.0639592952342 0 1.34768716813 -en 0.0665883991946 0 1.36652022769 -en 0.0693255748215 0 1.38731237887 -en 0.0721752644975 0 1.41002621657 -en 0.075142093213 0 1.43462484165 -en 0.0782308760729 0 1.46107073752 -en 0.0814466261113 0 1.48932465628 -en 0.0847945624273 0 1.51934450911 -en 0.088280118656 0 1.55108425779 -en 0.0919089517871 0 1.58449069323 -en 0.0956869513448 0 1.61949315092 -en 0.0996202489491 0 1.65600884699 -en 0.103715228266 0 1.6939449656 -en 0.107978535364 0 1.73319744531 -en 0.112417089509 0 1.77364981045 -en 0.117038094386 0 1.81517206499 -en 0.121849049797 0 1.8576196674 -en 0.126857763826 0 1.90083260785 -en 0.13207236552 0 1.9446346113 -en 0.137501318074 0 1.98883249266 -en 0.143153432572 0 2.03321569178 -en 0.149037882286 0 2.07755601766 -en 0.155164217561 0 2.12160763215 -en 0.16154238132 0 2.16510730377 -en 0.168182725197 0 2.20777496151 -en 0.17509602634 0 2.24931376549 -en 0.182293504902 0 2.28936251751 -en 0.189786842249 0 2.32746541907 -en 0.197588199921 0 2.36314106097 -en 0.205710239368 0 2.39589286604 -en 0.214166142502 0 2.42521407148 -en 0.222969633087 0 2.45059362742 -en 0.232134999016 0 2.47152298634 -en 0.241677115498 0 2.48750372727 -en 0.251611469201 0 2.49805592446 -en 0.261954183387 0 2.50272713399 -en 0.272722044078 0 2.50110183384 -en 0.2839325273 0 2.49281111585 -en 0.295603827449 0 2.47754239262 -en 0.307754886816 0 2.45504885099 -en 0.320405426331 0 2.42515835892 -en 0.333575977572 0 2.38778151513 -en 0.347287916087 0 2.34301777518 -en 0.361563496083 0 2.29189762247 -en 0.376425886545 0 2.23587769414 -en 0.391899208842 0 2.17635289628 -en 0.408008575873 0 2.11462948789 -en 0.424780132826 0 2.0519094373 -en 0.442241099608 0 1.98928166182 -en 0.460419815026 0 1.92771932582 -en 0.479345782778 0 1.86808228545 -en 0.499049719341 0 1.81112376136 -en 0.519563603815 0 1.75750037662 -en 0.540920729834 0 1.70778480021 -en 0.563155759595 0 1.66248037192 -en 0.586304780116 0 1.62203724166 -en 0.610405361801 0 1.58686972658 -en 0.635496619423 0 1.55737476842 -en 0.661619275603 0 1.53395044116 -en 0.688815726898 0 1.51664268561 -en 0.717130112616 0 1.50464082357 -en 0.74660838645 0 1.49707738732 -en 0.77729839106 0 1.49314412077 -en 0.809249935723 0 1.49207103313 -en 0.842514877169 0 1.49310993947 -en 0.877147203741 0 1.49552203095 -en 0.913203123043 0 1.49856922388 -en 0.950741153103 0 1.50150918503 -en 0.989822217422 0 1.50359402533 -en 1.0305097438 0 1.50407269785 -en 1.07286976729 0 1.50219712817 -en 1.11697103738 0 1.49723204595 -en 1.16288512958 0 1.4884683757 -en 1.21068656153 0 1.47523988571 -en 1.26045291406 0 1.45694259243 -en 1.31226495695 0 1.43310965292 -en 1.36620678015 0 1.40421375283 -en 1.42236593017 0 1.37142462381 -en 1.48083355222 0 1.33588658562 -en 1.54170453809 0 1.2986740587 -en 1.60507768021 0 1.2607752601 -en 1.67105583194 0 1.22308357032 -en 1.73974607453 0 1.18639561654 -en 1.8112598909 0 1.15141501031 -en 1.88571334657 0 1.11876068949 -en 1.96322727803 0 1.08897891816 -en 2.04392748889 0 1.06255817037 -en 2.127944954 0 1.03994634274 -en 2.21541603205 0 1.02156999414 -en 2.30648268691 0 1.0078555909 -en 2.40129271795 0 0.999253045764 -en 2.5 0 0.996262188529 > CEU_sweep_%d.ms", $n, $L, $theta, $meanRho, 3*$meanRho, $selend, $mutsel, $infreq, $i);
	
	print $line, "\n\n";
	
	`$line`;
}
