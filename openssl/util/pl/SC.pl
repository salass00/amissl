#!/usr/local/bin/perl
#
# SC.pl - SAS/C (Amiga) stuff.
#

$o='/';
$cp='cp';
$rm='-Delete QUIET FORCE';
$mkdir='MakeDir';

# C compiler stuff
$cc="sc";
$cfile="CSRC ";
# There's something strange with __bulitin_memcmp in SAS
#$cflags="CPU=\$(CPU_TYPE) \$(ADD) STRSECT=CODE DEF __USE_SYSBASE=1 DEF NO_CHMOD DEF NO_SYS_UN_H DEF NO_FP_API DEF __builtin_memcmp=memcmp DEF AMISSL DEF THREADS DEF B_ENDIAN DEF THIRTY_TWO_BITS IGN=55+72+154+161+304+306 NOSTKCHK STRMERGE ABSFUNCPOINTER IDLEN=100 MATH=STANDARD IDIR NetInclude: IDIR AmiSSL:include DEBUG=LINE OPT OPTGO OPTPEEP OPTLOOP OPTINL OPTINLOCAL OPTDEP=4 OPTSCHED";
$cflags="CPU=\$(CPU_TYPE) \$(ADD) STRSECT=CODE DEF __USE_SYSBASE=1 DEF NO_CHMOD DEF NO_SYS_UN_H DEF NO_FP_API DEF __builtin_memcmp=memcmp DEF AMISSL DEF THREADS DEF B_ENDIAN DEF THIRTY_TWO_BITS IGN=55+72+154+161+304+306 NOSTKCHK STRMERGE ABSFUNCPOINTER IDLEN=100 MATH=STANDARD IDIR NetInclude: IDIR AmiSSL:include DEBUG=LINE";
$obj='.o';
$ofile='OBJNAME ';
$compile='';
$define='DEF ';
$include='IDIR ';
$libm_cflag="DEF=MAIN_LIB_COMPILE";
$libc_cflag="DEF=CIPHER_LIB_COMPILE";

# EXE linking stuff
$link='${CC} LINK';
# either SAS bsearch is fubar'd or SSLeay doesn't like it...
$lflags='${CFLAG} NOICONS SMALLCODE "LINKOPTS=DEFINE _bsearch=_OBJ_bsearch"';
$efile='TO ';
$exep='';
$ex_libs="NetLib:miami.lib AmiSSL:obj/mystdio.o";

# static library stuff
$mklib='oml';
$libadd='a';
$mlflags='';
$ranlib='';
$plib='';
$libp=".lib";
$shlibp=".lib";
$lfile='';

$asm='asm';
$afile='-o ';
$bn_mulw_obj="";
$bn_mulw_src="";
$des_enc_obj="";
$des_enc_src="";
$bf_enc_obj="";
$bf_enc_src="";

$src_dir=~ s/\.$//;
$quotequote='*"';
$quote='"';
$ignmkdir='-';
$maxchars=2048;

sub do_lib_rule
	{
	local($obj,$target,$name,$shlib)=@_;
	local($ret,$_,$Name);
	
	$target =~ s/\//$o/g if $o ne '/';
	($Name=$name) =~ tr/a-z/A-Z/;

	$ret.="$target: \$(${Name}OBJ)\n";
	$ret.="\t-\$(RM) $target\n";
	$ret.="\t\$(MKLIB) $target $libadd \$(${Name}OBJ)\n\n";
	}

sub do_link_rule
	{
	local($target,$files,$dep_libs,$libs)=@_;
	local($ret,$_);
	
	$file =~ s/\//$o/g if $o ne '/';
	$n=&bname($target);
	$ret.="$target: $files $dep_libs\n";
	$ret.="\t\$(LINK) ${efile}$target \$(LFLAGS) FROM $files LIB $libs\n\n";
	return($ret);
	}

1;