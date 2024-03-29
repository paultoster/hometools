#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      lino
#
# Created:     08.02.2024
# Copyright:   (c) lino 2024
# Licence:     <your licence>
#-------------------------------------------------------------------------------
import vpython as vp
import time
from typing import List
import numpy as np

class CBrettParam:
  P0   : np.ndarray              # Eckpunkt des Bretts
  L    : float                   # Länge des Bretts
  Ldir : np.ndarray              # Richtung Länge des Bretts
  B    : float                   # Breite des Bretts
  Bdir : np.ndarray              # Richtung Breite des Bretts
  H    : float                   # Höhe des Bretts
  Hdir : np.ndarray              # Richtung Höhe des Bretts

class CBrett:
  ''' Beschreibung rechteckiges Brett'''
  def __init__(self,par: CBrettParam):
    self.par = par
    self.object = None

  def plot(self,color: vp.vector ):

    self.par.Ldir = self.par.Ldir/np.linalg.norm(self.par.Ldir)
    self.par.Bdir = self.par.Bdir/np.linalg.norm(self.par.Bdir)
    self.par.Hdir = self.par.Hdir/np.linalg.norm(self.par.Hdir)

    LBH    = self.par.Ldir * abs(self.par.L) \
           + self.par.Bdir * abs(self.par.B) \
           + self.par.Hdir * abs(self.par.H)
    PMitte = self.par.P0 \
           + self.par.Ldir * abs(self.par.L*0.5) \
           + self.par.Bdir * abs(self.par.B*0.5) \
           + self.par.Hdir * abs(self.par.H*0.5)


    self.object = vp.box( pos=vp.vec(PMitte[0],PMitte[1],PMitte[2])
                        , size=vp.vec(LBH[0],LBH[1],LBH[2])
                        , color = color
                        )
  def plot2(self,color: vp.vector ):

    self.par.Ldir = self.par.Ldir/np.linalg.norm(self.par.Ldir)
    self.par.Bdir = self.par.Bdir/np.linalg.norm(self.par.Bdir)
    self.par.Hdir = self.par.Hdir/np.linalg.norm(self.par.Hdir)

    LBH    = self.par.Ldir * abs(self.par.L) \
           + self.par.Bdir * abs(self.par.B) \
           + self.par.Hdir * abs(self.par.H)

    self.axis = self.par.Ldir+self.par.Bdir+self.par.Hdir

    self.object = vp.box( pos=vp.vec(self.par.P0[0],self.par.P0[1],self.par.P0[2]) \
                        , axis=vp.vec(self.axis[0],self.axis[1],self.axis[2]) \
                        , length = abs(LBH[0]) \
                        , width  = abs(LBH[1]) \
                        , height = abs(LBH[2]) \
                        , color  = color \
                        )

  #enddef
  def rotate(self,axis,angle,origin):

    if( self.object != None ):
      self.object.rotate(axis=vp.vec(axis[0], axis[1],axis[2]) \
                        ,angle=angle \
                        ,origin=vp.vec(origin[0], origin[1],origin[2]))

  #enddef


class CParameter:
  ''' Parameter data'''

  # screen
  #-------
  Hscreen                = int(360*2)   # screen height pixel
  Wscreen                = int(480*2)   # screen width pixel

  # axis description
  #-----------------
  Laxis                       = float(200)       #  length of axis
  Raxis                       = float(1)    # radius of axis
  FaxisTextPos: float         = 1.02    # factor prolonging over axis for postion text
  fac_height_axis_text: float = 0.2     # factor to scale height of text with length of axis
  HaxisText                   = Laxis * fac_height_axis_text   # height of text axis

  Hoehe  = 150
  Breite = 100
  Tiefe = 40
  Dicke = 3

  Tischhoehe = 70
  Spalt      = 0.3

  # Bodenplatte
  Boden      = CBrettParam()
  Boden.P0   = np.asarray([0,0,0])     # Exkpunkt Boden
  Boden.L    = Breite                    # [cm] Länge des Bretts
  Boden.Ldir = np.asarray([1.,0.,0.])  # Richtung Länge
  Boden.B    = Tiefe                   # [cm] Breite des Bretts
  Boden.Bdir = np.asarray([0.,0.,-1.]) # Richtung Länge
  Boden.H    = Dicke                   # [cm] Breite des Bretts
  Boden.Hdir = np.asarray([0.,1.,0.])  # Richtung Länge

  SeiteLinks      = CBrettParam()
  SeiteLinks.P0   = np.asarray([0,0,0])     # Exkpunkt Boden
  SeiteLinks.L    = Hoehe                  # [cm] Länge des Bretts
  SeiteLinks.Ldir = np.asarray([0.,1.,0.])  # Richtung Länge
  SeiteLinks.B    = Tiefe                   # [cm] Breite des Bretts
  SeiteLinks.Bdir = np.asarray([0.,0.,-1.]) # Richtung Länge
  SeiteLinks.H    = Dicke                   # [cm] Breite des Bretts
  SeiteLinks.Hdir = np.asarray([-1.,0.,0.])  # Richtung Länge

  SeiteRechts      = CBrettParam()
  SeiteRechts.P0   = np.asarray([Breite,0,0])     # Exkpunkt Boden
  SeiteRechts.L    = Hoehe                   # [cm] Länge des Bretts
  SeiteRechts.Ldir = np.asarray([0.,1.,0.])  # Richtung Länge
  SeiteRechts.B    = Tiefe                   # [cm] Breite des Bretts
  SeiteRechts.Bdir = np.asarray([0.,0.,-1.]) # Richtung Länge
  SeiteRechts.H    = Dicke                    # [cm] Breite des Bretts
  SeiteRechts.Hdir = np.asarray([1.,0.,0.])  # Richtung Länge

  Oberteil      = CBrettParam()
  Oberteil.P0   = np.asarray([-Dicke,Hoehe,0])     # Exkpunkt Boden
  Oberteil.L    = Breite+2*Dicke                    # [cm] Länge des Bretts
  Oberteil.Ldir = np.asarray([1.,0.,0.])  # Richtung Länge
  Oberteil.B    = Tiefe                   # [cm] Breite des Bretts
  Oberteil.Bdir = np.asarray([0.,0.,-1.]) # Richtung Länge
  Oberteil.H    = Dicke                    # [cm] Breite des Bretts
  Oberteil.Hdir = np.asarray([0.,1.,0.])  # Richtung Länge

  Innentisch      = CBrettParam()
  Innentisch.P0   = np.asarray([0,Tischhoehe,0])     # Exkpunkt Boden
  Innentisch.L    = Breite                   # [cm] Länge des Bretts
  Innentisch.Ldir = np.asarray([1.,0.,0.])  # Richtung Länge
  Innentisch.B    = Tiefe                   # [cm] Breite des Bretts
  Innentisch.Bdir = np.asarray([0.,0.,-1.]) # Richtung Länge
  Innentisch.H    = Dicke                     # [cm] Breite des Bretts
  Innentisch.Hdir = np.asarray([0.,-1.,0.])  # Richtung Länge

  Tuertisch      = CBrettParam()
  Tuertisch.P0   = np.asarray([-Dicke,Tischhoehe,0])     # Exkpunkt Boden
  Tuertisch.L    = Breite+2*Dicke                        # [cm] Länge des Bretts
  Tuertisch.Ldir = np.asarray([1.,0.,0.])                # Richtung Länge
  Tuertisch.B    = Hoehe - Tischhoehe + Dicke            # [cm] Breite des Bretts
  Tuertisch.Bdir = np.asarray([0.,1.,0.]) # Richtung Länge
  Tuertisch.H    = Dicke                     # [cm] Breite des Bretts
  Tuertisch.Hdir = np.asarray([0.,0.,1.])  # Richtung Länge

  TuerULinks      = CBrettParam()
  # TuerULinks.P0   = np.asarray([-Dicke,0,0])     # Exkpunkt Boden
  TuerULinks.P0   = np.asarray([0,0,0])     # Exkpunkt Boden
  # TuerULinks.L    = Breite*0.5+Dicke-Spalt                        # [cm] Länge des Bretts
  TuerULinks.L    = Breite*0.5-Spalt                        # [cm] Länge des Bretts
  TuerULinks.Ldir = np.asarray([1.,0.,0.])                # Richtung Länge
  TuerULinks.B    = Tischhoehe - Dicke            # [cm] Breite des Bretts
  TuerULinks.Bdir = np.asarray([0.,1.,0.]) # Richtung Länge
  TuerULinks.H    = Dicke                     # [cm] Breite des Bretts
  TuerULinks.Hdir = np.asarray([0.,0.,1.])  # Richtung Länge

  TuerURechts      = CBrettParam()
  # TuerURechts.P0   = np.asarray([Breite+Dicke,0,0])     # Exkpunkt Boden
  TuerURechts.P0   = np.asarray([Breite,0,0])     # Exkpunkt Boden
  # TuerURechts.L    = Breite*0.5+Dicke-Spalt                        # [cm] Länge des Bretts
  TuerURechts.L    = Breite*0.5-Spalt                        # [cm] Länge des Bretts
  TuerURechts.Ldir = np.asarray([-1.,0.,0.])                # Richtung Länge
  TuerURechts.B    = Tischhoehe - Dicke            # [cm] Breite des Bretts
  TuerURechts.Bdir = np.asarray([0.,1.,0.])        # Richtung Länge
  TuerURechts.H    = Dicke                         # [cm] Breite des Bretts
  TuerURechts.Hdir = np.asarray([0.,0.,1.])        # Richtung Länge

  #enddef
#endclass

def plot_axis(par: CParameter) -> None:
  ''' Plot axis '''
  xaxis = vp.cylinder(pos=vp.vec(0,0,0), axis=vp.vec(par.Laxis,0,0), radius=par.Raxis, color=vp.color.yellow)
  yaxis = vp.cylinder(pos=vp.vec(0,0,0), axis=vp.vec(0,par.Laxis,0), radius=par.Raxis, color=vp.color.yellow)
  zaxis = vp.cylinder(pos=vp.vec(0,0,0), axis=vp.vec(0,0,par.Laxis), radius=par.Raxis, color=vp.color.yellow)

  vp.text(pos=xaxis.pos+par.FaxisTextPos*xaxis.axis, text='x', height=par.HaxisText, align='center', billboard=True, emissive=True)
  vp.text(pos=yaxis.pos+par.FaxisTextPos*yaxis.axis, text='y', height=par.HaxisText, align='center', billboard=True, emissive=True)
  vp.text(pos=zaxis.pos+par.FaxisTextPos*zaxis.axis, text='z', height=par.HaxisText, align='center', billboard=True, emissive=True)

#enddef

def main():

  par = CParameter()

  scene = vp.canvas(
            height=par.Hscreen,
            width=par.Wscreen,
            title="Test Graphics Canvas Creation",
            caption="",
            grid=False)

  plot_axis(par)

  boden = CBrett(par.Boden)
  boden.plot(vp.color.white)

  seiteLinks = CBrett(par.SeiteLinks)
  seiteLinks.plot(vp.color.white)

  seiteRechts = CBrett(par.SeiteRechts)
  seiteRechts.plot(vp.color.white)

  oberteil = CBrett(par.Oberteil)
  oberteil.plot(vp.color.white)

  innentisch = CBrett(par.Innentisch)
  innentisch.plot(vp.color.white)

  tuertisch = CBrett(par.Tuertisch)
  tuertisch.plot(vp.color.white)

  tuerlinks = CBrett(par.TuerULinks)
  tuerlinks.plot(vp.color.white)

  tuerrechts = CBrett(par.TuerURechts)
  tuerrechts.plot(vp.color.white)

  # tuertisch.rotate(axis=par.Tuertisch.Ldir,angle=np.pi/2,origin=par.Tuertisch.P0)

  # floor = vp.box(canvas=scene,pos=vp.vector(0,-5,0), size=vp.vector(10,0.1,10),color=vp.color.white)

  dd = np.pi/100;
  nstop    = int(np.pi/2. / dd + 0.5)+1
  n        = 0
  swdir    = 1

  while True:
    vp.rate(30)

    if( swdir == 1 ):
      delta   = dd
      n        += 1
      if( n == nstop ):
        delta = 0.0
        swdir = 2
        n     = 0
      #endif
    elif(swdir == 2 ):
      delta   = 0.0
      n       += 1
      if( n == nstop):
        swdir = 3
        n     = 0
      #endif
    elif(swdir == 3 ):
      n += 1
      delta   = -dd
      if( n == nstop ):
        n     = 0
        delta = 0.0
        swdir = 4
      #endif
    else:
      delta   = 0.0
      n       += 1
      if( n == nstop):
        swdir = 1
        n = 0
      #endif
    #endif

    # print(f"n={n}, nstop={nstop}, dd={dd}, swdir={swdir}")
    tuertisch.rotate(axis=par.Tuertisch.Ldir,angle=delta,origin=par.Tuertisch.P0)
    tuerlinks.rotate(axis=par.TuerULinks.Bdir,angle=-delta,origin=par.TuerULinks.P0)
    tuerrechts.rotate(axis=par.TuerURechts.Bdir,angle=delta,origin=par.TuerURechts.P0)
if __name__ == '__main__':
    main()
