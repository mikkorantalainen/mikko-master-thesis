\def\filedate{2003/04/15}
\def\fileversion{1.0}
\def\fileinfo{JY MIT: seminaarityot}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{jyumitsem}[\filedate\space\fileversion\space\fileinfo]
\typeout{jyumitsem <\filedate:\fileversion> - JY MIT seminaarityot}

\newif\iffi
\fitrue

\def\jyumitsem@inputenc{latin1}
\DeclareOption{ansinew}{\gdef\jyumitsem@inputenc{ansinew}}
\DeclareOption{applemac}{\gdef\jyumitsem@inputenc{applemac}}
\DeclareOption{ascii}{\gdef\jyumitsem@inputenc{ascii}}
\DeclareOption{cp1250}{\gdef\jyumitsem@inputenc{cp1250}}
\DeclareOption{cp1252}{\gdef\jyumitsem@inputenc{cp1252}}
\DeclareOption{cp437}{\gdef\jyumitsem@inputenc{cp437}}
\DeclareOption{cp437de}{\gdef\jyumitsem@inputenc{cp437de}}
\DeclareOption{cp850}{\gdef\jyumitsem@inputenc{cp850}}
\DeclareOption{cp852}{\gdef\jyumitsem@inputenc{cp852}}
\DeclareOption{cp865}{\gdef\jyumitsem@inputenc{cp865}}
\DeclareOption{decmulti}{\gdef\jyumitsem@inputenc{decmulti}}
\DeclareOption{latin1}{\gdef\jyumitsem@inputenc{latin1}}
\DeclareOption{latin2}{\gdef\jyumitsem@inputenc{latin2}}
\DeclareOption{latin3}{\gdef\jyumitsem@inputenc{latin3}}
\DeclareOption{latin5}{\gdef\jyumitsem@inputenc{latin5}}
\DeclareOption{latin9}{\gdef\jyumitsem@inputenc{latin9}}
\DeclareOption{next}{\gdef\jyumitsem@inputenc{next}}

\def\jyumitsem@julkaisu{Anna kirjoitelmaluokalle sopiva optio (esim. \texttt{vok2003})!}
\DeclareOption{ohje}{%
\def\jyumitsem@julkaisu{Opiskelijat\"oit\"a -sarjan ep\"avirallinen ohje, Jyv\"askyl\"an yliopisto, tietotekniikan laitos.}%
}
\DeclareOption{vok2003}{%
\def\jyumitsem@julkaisu{Virtuaaliset oppimisymp\"arist\"ot, loppuseminaari 24.4.2003, Jyv\"askyl\"an yliopisto, tietotekniikan laitos.}%
}

\DeclareOption{finnish}{\fitrue}
\DeclareOption{english}{\fifalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{artikel3}}

\ProcessOptions
\LoadClass[a4paper,10pt,twocolumn,twoside]{artikel3}

\RequirePackage[\jyumitsem@inputenc]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[left=35mm,right=30mm,top=25mm,bottom=35mm]{geometry}
\RequirePackage[finnish,english]{babel}
\RequirePackage{ifthen}
\RequirePackage{palatcm}
\RequirePackage{url}
\RequirePackage{hyperref}

\urlstyle{sl}

\def\jyumitsem@title{}
\def\jyumitsem@shorttitle{}
\def\jyumitsem@authors{}
\def\jyumitsem@authorh{}
\let\jyumitsem@authorstart\relax
\let\jyumitsem@authorsep\relax
\let\jyumitsem@authorend\relax
\renewcommand{\title}[2][\DefaultOption]{\gdef\jyumitsem@title{#2}\gdef\jyumitsem@shorttitile{#1}}
\renewcommand{\author}[2]{%
  \@cons\jyumitsem@authors{\jyumitsem@authorstart#1\jyumitsem@authorsep#2\jyumitsem@authorend}
}
\newcounter{jyumitsem@authorcount}
\renewcommand{\maketitle}{
  \begin{centering}
    \bfseries
    {\LARGE \jyumitsem@title}\\[1em]
    \def\jyumitsem@authorstart{%
      \ifthenelse{\value{jyumitsem@authorcount} = 3}{%
        \par%
        \setcounter{jyumitsem@authorcount}{0}%
      }{%
        \addtocounter{jyumitsem@authorcount}{1}%
      }
      \begin{tabular}[t]{c}\Large
      }
      \def\jyumitsem@authorsep{\\[0.2em]\large}
      \def\jyumitsem@authorend{\end{tabular}}
    \jyumitsem@authors\par
  \end{centering}
  \vskip2em
}

\renewcommand{\abstract}[1]{%
  \twocolumn[%
    \begin{@twocolumnfalse}%
      \maketitle%
      \begin{center}
        \textbf{\abstractname}\par
        \medskip
        \begin{minipage}{7cm}\raggedright
          \footnotesize
          #1
        \end{minipage}
      \end{center}
      \vskip1em
      \end{@twocolumnfalse}%
  ]%
}

\def\ps@plain{%
  \def\@evenfoot{\thepage\hfil\textsf{\footnotesize\jyumitsem@julkaisu}}
  \def\@oddfoot{\textsf{\footnotesize\jyumitsem@julkaisu}\hfil\thepage}
  \let\@evenhead\@empty\let\@oddhead\@empty
}

\AtBeginDocument{%
\iffi
\selectlanguage{finnish}
\else
\selectlanguage{english}
\fi
\pagestyle{plain}
%  \maketitle%
}

\let\jyumitsemjulkaisu\jyumitsem@julkaisu

\ifx\sc\undefined
    \def\sc{%
      % If there is no \scriptfont for the current family, use a fixed
      % font.  What more can we do?
      \expandafter\ifx\the\scriptfont\fam\nullfont
        \font\temp = cmr7 \temp
      \else
        \the\scriptfont\fam
      \fi
      \def\uppercasesc{\char\uccode`}%
    }%
\fi
\ifx\uppercasesc\undefined
  \let\uppercasesc = \relax
\fi
\ifx\BibTeX\undefined
    \def\BibTeX{B{\sc \uppercasesc i\kern-.025em \uppercasesc b}\kern-.08em%
                \TeX}%
\fi
