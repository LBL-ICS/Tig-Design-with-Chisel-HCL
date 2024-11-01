package Trig
import chisel3._

import java.io.PrintWriter
import chisel3.util._
import Binary_Modules.BinaryDesigns._
import FP_Modules.FloatingPointDesigns._
import chisel3.stage.ChiselStage

object Main extends App {
    val pw = new PrintWriter("Cos.v")
    pw.println(getVerilogString(new Cos(32,16)))
      pw.close()

  val pw2 = new PrintWriter("Sin.v")
  pw2.println(getVerilogString(new Sin(32,1)))
  pw2.close()
}
