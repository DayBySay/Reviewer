//
//  Executor.swift
//  Reviewer
//
//  Created by Takayuki Sei on 2020/08/08.
//

import Foundation
import ReviewerFramework
import TSCUtility

class Executor {
  private let id: PositionalArgument<Int>
  private let page: OptionArgument<Int>
  private let format: OptionArgument<String>

  init(parser: ArgumentParser) {
    id = parser.add(
      positional: "id", kind: Int.self, usage: "Identifier of app to get data, e.g. 284815942")
    page = parser.add(
      option: "--page",
      shortName: "-p",
      kind: Int.self,
      usage: "Get a specific pages reviews. Default is not specified")
    format = parser.add(
      option: "--format",
      shortName: "-f",
      kind: String.self,
      usage: "Specify output format. Default is set JSON. Available JSON or XML.")
  }

  func execute(args: ArgumentParser.Result) {
    let id = args.get(self.id) ?? 0
    let page = args.get(self.page) ?? -1
    let format = args.get(self.format) ?? "JSON"
    do {
      try generate(id: id, page: page, format: format) { (string) in
        print(string)
        exit(0)
      }
    } catch {
      print("Error: \(error.localizedDescription)")
      fatalError("Fetch reviews error: \(error)")
    }
  }

}
