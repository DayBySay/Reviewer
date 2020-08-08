import Foundation
import TSCUtility

func main() {
  let parser = ArgumentParser(usage: "id <option>", overview: "iTunes Customer Reviews Parser")

  let command = Executor(parser: parser)
  let inputs = Array(CommandLine.arguments.dropFirst())

  do {
    let args = try parser.parse(inputs)
    command.execute(args: args)
  } catch {
    fatalError("Command-line pasing error: \(error)")
  }
}

main()

dispatchMain()
