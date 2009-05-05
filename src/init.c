/*
#   xts: eXtensible time-series 
#
#   Copyright (C) 2008  Jeffrey A. Ryan jeff.a.ryan @ gmail.com
#
#   Contributions from Joshua M. Ulrich
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


#include "xts.h"
#include <R_ext/Rdynload.h>

static const
R_CallMethodDef callMethods[] = {
  {"add_class",             (DL_FUNC) &add_class,               2},
  {"coredata",              (DL_FUNC) &coredata,                1},
  {"do_xtsAttributes",      (DL_FUNC) &do_xtsAttributes,        1},
  {"do_xtsCoreAttributes",  (DL_FUNC) &do_xtsCoreAttributes,    1},
  {"lagXts",                (DL_FUNC) &lagXts,                  3},
  {"do_is_ordered",         (DL_FUNC) &do_is_ordered,           3},
  {"isXts",                 (DL_FUNC) &isXts,                   1},
  {"tryXts",                (DL_FUNC) &tryXts,                  1},
  {"do_rbind_xts",          (DL_FUNC) &do_rbind_xts,            3},
  {"do_subset_xts",         (DL_FUNC) &do_subset_xts,           4},
  {NULL,                    NULL,                               0}
};

static const
R_ExternalMethodDef externalMethods[] = {
  {"number_of_cols",        (DL_FUNC) &number_of_cols,          1},
  {"mergeXts",              (DL_FUNC) &mergeXts,                1},
  {"rbindXts",              (DL_FUNC) &rbindXts,                1},
  {NULL,                    NULL,                               0}
};

void R_init_xts(DllInfo *info)
{
  R_registerRoutines(info,
                     NULL,
                     callMethods,
                     NULL,
                     externalMethods);

  R_useDynamicSymbols(info, TRUE);
#define RegisterXTS(routine) R_RegisterCCallable("xts","routine",(DL_FUNC) &routine)

  /* used by external packages linking to internal xts code from C */
  R_RegisterCCallable("xts",    "do_is_ordered",    (DL_FUNC) &do_is_ordered    );
  R_RegisterCCallable("xts",    "coredata",         (DL_FUNC) &coredata         );
  R_RegisterCCallable("xts",    "isXts",            (DL_FUNC) &isXts            );
  R_RegisterCCallable("xts",    "tryXts",           (DL_FUNC) &tryXts           );
  RegisterXTS(rbindXts);
}