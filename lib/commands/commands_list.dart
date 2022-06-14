import 'impl/commands_export.dart';
import 'interface/command.dart';

final List<Command> commands = [
  CreateCommand(),
  HelpCommand(),
  VersionCommand(),
  InitCommand(),
  InstallCommand(),
  RemoveCommand(),
  SortCommand(),
  UpdateCommand(),
];
