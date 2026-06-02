//
//  SatelliteElements.swift
//  ISS Tracker
//
//  Created by Mark Bush on 08/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import Foundation

struct SatelliteElements {
  var xmo = 0.0
  var xnodeo = 0.0
  var omegao = 0.0
  var eo = 0.0
  var xincl = 0.0
  var xndd60 = 0.0
  var bstar = 0.0
  var xno = 0.0
  var xndt20 = 0.0
  var epoch = 0.0
  func actan(sinx: Double, _ cosx: Double) -> Double {
    var ret = 0.0
    if cosx < 0.0 {
      ret = M_PI
    } else if cosx == 0.0 {
      if sinx < 0.0 {
        return 3.0 * M_PI_2
      } else if(sinx == 0.0) {
        return ret
      } else /* sinx > 0.0 */ {
        return M_PI_2
      }
    } else /* cosx > 0.0 */ {
      if sinx < 0.0 {
        ret = 2.0 * M_PI
      } else if sinx == 0.0 {
        return ret
      }
    }
    return ret + atan(sinx / cosx)
  }
  func sgp4(tsince: Double) -> (position: Vec3, velocity: Vec3) {
    var isSimple = false

    let tothrd = 2.0 / 3.0
    let xke = 0.743669161e-1
    let ck2 = 5.413080e-04
    let ck4 = 6.209887e-07
    let ae = 1.0
    let xkmper = 6378.135
    let s = 1.012229e+00
    let qoms2t = 1.880279e-09
    let xj3 = -0.253881e-5
    let e6a = 1.0e-12

    var sinepw = 0.0
    var cosepw = 0.0
    var temp4 = 0.0
    var temp5 = 0.0
    var temp6 = 0.0
    var t3cof = 0.0
    var t4cof = 0.0
    var t5cof = 0.0
    var temp = 0.0
    var d2 = 0.0
    var d3 = 0.0
    var d4 = 0.0
    let a1 = pow(xke / xno, tothrd)
    let cosio = cos(xincl)
    let theta2 = cosio * cosio
    let x3thm1 = 3.0 * theta2 - 1.0
    let eosq = eo * eo
    let betao2 = 1.0 - eosq
    let betao = sqrt(betao2)
    let del1 = 1.5 * ck2 * x3thm1 / (a1 * a1 * betao * betao2)
    let ao = a1 * (1.0 - del1 * (0.5 * tothrd +
      del1 * (1.0 + 134.0 / 81.0 * del1)))
    let delo = 1.5 * ck2 * x3thm1 / (ao * ao * betao * betao2)
    let xnodp = xno / (1.0 + delo)
    let aodp = ao / (1.0 - delo)

    if (aodp * (1.0 - eo) / ae) < (220.0 / xkmper + ae) {
      isSimple = true
    }

    var s4 = s
    var qoms24 = qoms2t
    let perigee = (aodp * (1.0 - eo) - ae) * xkmper
    if perigee < 156.0 {
      s4 = perigee - 78.0
      if perigee <= 98.0 {
        s4 = 20.0
      }
      qoms24 = pow(((120.0 - s4) * ae / xkmper), 4.0)
      s4 = s4 / xkmper + ae
    }
    let pinvsq = 1.0 / (aodp * aodp * betao2 * betao2)
    let tsi = 1.0 / (aodp - s4)
    let eta = aodp * eo * tsi
    let etasq = eta * eta
    let eeta = eo * eta
    let psisq = fabs(1.0 - etasq)
    let coef = qoms24 * pow(tsi, 4.0)
    let coef1 = coef / pow(psisq, 3.5)
    let c2 = coef1 * xnodp * (aodp * (1.0 + 1.5 * etasq +
      eeta * (4.0 + etasq)) + 0.75 *
      ck2 * tsi /
      psisq * x3thm1 * (8.0 +
        3.0 * etasq * (8.0 + etasq)))

    let c1 = bstar * c2
    let sinio = sin(xincl)
    let a3ovk2 = -xj3 / ck2 * pow(ae, 3.0)
    let c3 = coef * tsi * a3ovk2 * xnodp * ae * sinio / eo
    let x1mth2 = 1.0 - theta2
    let c41 = 2.0 * xnodp * coef1 * aodp * betao2
    let c421 = eta * (2.0 + (0.5 * etasq))
    let c422 = eo * (0.5 + (2.0 * etasq))
    let c423 = 2.0 * ck2 * tsi / (aodp * psisq)
    let c4241 = -3.0 * x3thm1 * (1.0 - (2.0 * eeta) + (etasq * (1.5 - (0.5 * eeta))))
    let c4242 = 0.75 * x1mth2 * ((2.0 * etasq) - (eeta * (1.0 + etasq))) * cos(2.0 * omegao)
    let c424 = c4241 + c4242
    let c42 = c421 + c422 - (c423 * c424)
    let c4 = c41 * c42
    let c5 = 2.0 * coef1 * aodp * betao2 * (1.0 +
      2.75 * (etasq + eeta) +
      eeta * etasq)
    let theta4 = theta2 * theta2
    var temp1 = 3.0 * ck2 * pinvsq * xnodp
    var temp2 = temp1 * ck2 * pinvsq
    var temp3 = 1.25 * ck4 * pinvsq * pinvsq * xnodp

    let xmdot = xnodp +
      (0.5 * temp1 * betao * x3thm1) +
      (0.0625 * temp2 * betao * (13.0 - (78.0 * theta2) + (137.0 * theta4)))
    let x1m5th = 1.0 - (5.0 * theta2)
    let omgdot = (-0.5 * temp1 * x1m5th) +
      (0.0625 * temp2 * (7.0 - (114.0 * theta2) + (395.0 * theta4))) +
      (temp3 * (3.0 - (36.0 * theta2) + (49.0 * theta4)))
    let xhdot1 = -temp1 * cosio
    let xnodot = xhdot1 + ((0.5 * temp2 * (4.0 - (19.0 * theta2)) + 2.0 * temp3 * (3.0 - (7.0 * theta2))) * cosio)
    let omgcof = bstar * c3 * cos(omegao)
    let xmcof = -tothrd * coef * bstar * ae / eeta
    let xnodcf = 3.5 * betao2 * xhdot1 * c1
    let t2cof = 1.5 * c1
    let xlcof = 0.125 * a3ovk2 * sinio * (3.0 + (5.0 * cosio)) / (1.0 + cosio)
    let aycof = 0.25 * a3ovk2 * sinio
    let delmo = pow(1.0 + (eta * cos(xmo)), 3.0)
    let sinmo = sin(xmo)
    let x7thm1 = (7.0 * theta2) - 1.0

    if !isSimple {
      let c1sq = c1 * c1
      d2 = 4.0 * aodp * tsi * c1sq
      temp = d2 * tsi * c1 / 3.0
      d3 = ((17.0 * aodp) + s4) * temp
      d4 = 0.5 * temp * aodp * tsi * ((221.0 * aodp) + (31.0 * s4)) * c1
      t3cof = d2 + (2.0 * c1sq)
      t4cof = 0.25 * ((3.0 * d3) + (c1 * ((12.0 * d2) + (10.0 * c1sq))))
      t5cof = 0.2 * ((3.0 * d4) + (12.0 * c1 * d3) + (6.0 * d2 * d2) + (15.0 * c1sq * ((2.0 * d2) + c1sq)))
    }

    let xmdf = xmo + (xmdot * tsince)
    let omgadf = omegao + (omgdot * tsince)
    let xnoddf = xnodeo + (xnodot * tsince)
    var omega = omgadf
    var xmp = xmdf
    let tsq = tsince * tsince
    let xnode = xnoddf + (xnodcf * tsq)
    var tempa = 1.0 - (c1 * tsince)
    var tempe = bstar * c4 * tsince
    var templ = t2cof * tsq
    if !isSimple {
      let delomg = omgcof * tsince
      let delm = xmcof * (pow(1.0 + (eta * cos(xmdf)), 3) - delmo)
      temp = delomg + delm
      xmp = xmdf + temp
      omega = omgadf - temp
      let tcube = tsq * tsince
      let tfour = tsince * tcube
      tempa = tempa - (d2 * tsq) - (d3 * tcube) - (d4 * tfour)
      tempe = tempe + (bstar * c5 * (sin(xmp) - sinmo))
      templ = templ + (t3cof * tcube) + (tfour * (t4cof + (tsince * t5cof)))
    }
    let a = aodp * tempa * tempa
    let e = eo - tempe
    let xl = xmp + omega + xnode + (xnodp * templ)
    let beta = sqrt(1.0 - (e * e))
    let xn = xke / pow(a, 1.5)

    let axn = e * cos(omega)
    temp = 1.0 / (a * beta * beta)
    let xll = temp * xlcof * axn
    let aynl = temp * aycof
    let xlt = xl + xll
    let ayn = (e * sin(omega)) + aynl

    let capu = fmod(xlt - xnode, 2.0 * M_PI)
    temp2 = capu
    for _ in 0..<10 {
      sinepw = sin(temp2)
      cosepw = cos(temp2)
      temp3 = axn * sinepw
      temp4 = ayn * cosepw
      temp5 = axn * cosepw
      temp6 = ayn * sinepw
      let epw = (capu - temp4 + temp3 - temp2) / (1.0 - temp5 - temp6) + temp2
      if fabs(epw - temp2) <= e6a {
        break
      }
      temp2 = epw
    }

    let ecose = temp5 + temp6
    let esine = temp3 - temp4
    let elsq = (axn * axn) + (ayn * ayn)
    temp = 1.0 - elsq
    let pl = a * temp
    let r = a * (1.0 - ecose)
    temp1 = 1.0 / r
    let rDot = xke * sqrt(a) * esine * temp1
    let rfDot = xke * sqrt(pl) * temp1
    temp2 = a * temp1
    let betal = sqrt(temp)
    temp3 = 1.0 / (1.0 + betal)
    let cosu = temp2 * (cosepw - axn + (ayn * esine * temp3))
    let sinu = temp2 * (sinepw - ayn - (axn * esine * temp3))
    let u = actan(sinu, cosu)
    let sin2u = 2.0 * sinu * cosu
    let cos2u = (2.0 * cosu * cosu) - 1.0
    temp = 1.0 / pl
    temp1 = ck2 * temp
    temp2 = temp1 * temp

    let rk = (r * (1.0 - (1.5 * temp2 * betal * x3thm1))) + (0.5 * temp1 * x1mth2 * cos2u)
    let uk = u - (0.25 * temp2 * x7thm1 * sin2u)
    let xnodek = xnode + (1.5 * temp2 * cosio * sin2u)
    let xinck = xincl + (1.5 * temp2 * cosio * sinio * cos2u)
    let rDotK = rDot - (xn * temp1 * x1mth2 * sin2u)
    let rfDotK = rfDot + (xn * temp1 * ((x1mth2 * cos2u) + (1.5 * x3thm1)))

    let sinuk = sin(uk)
    let cosuk = cos(uk)
    let sinik = sin(xinck)
    let cosik = cos(xinck)
    let sinnok = sin(xnodek)
    let cosnok = cos(xnodek)

    let xmx = -sinnok * cosik
    let xmy = cosnok * cosik

    let ux = (xmx * sinuk) + (cosnok * cosuk)
    let uy = (xmy * sinuk) + (sinnok * cosuk)
    let uz = sinik * sinuk

    let vx = (xmx * cosuk) - (cosnok * sinuk)
    let vy = (xmy * cosuk) - (sinnok * sinuk)
    let vz = sinik * cosuk

    let position = Vec3(x: rk * ux, y: rk * uy, z: rk * uz)
    let velocityX = (rDotK * ux) + (rfDotK * vx)
    let velocityY = (rDotK * uy) + (rfDotK * vy)
    let velocityZ = (rDotK * uz) + (rfDotK * vz)
    let velocity = Vec3(x: velocityX, y: velocityY, z: velocityZ)
    return (position, velocity)
  }
  func sdp4(offsetMinutes: Double) -> (position: Vec3, velocity: Vec3) {
    return (Vec3(x: 1e-7, y: 1e-7, z: 1e-7), Vec3())
  }
}
