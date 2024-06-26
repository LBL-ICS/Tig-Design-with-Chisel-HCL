package Trig
import chisel3._

import java.io.PrintWriter
import chisel3.util._
import Binary_Modules.BinaryDesigns._
import FP_Modules.FloatingPointDesigns._
import chisel3.stage.ChiselStage

object Main extends App {
    val pw = new PrintWriter("Atan.v")
    pw.println(getVerilogString(new Atan()))
      pw.close()
}
