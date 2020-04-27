# v8源码分析

版本：v8-0.1.5，  
下载地址： [https://chromium.googlesource.com/v8/v8.git](https://chromium.googlesource.com/v8/v8.git)  
入口文件：由于版本太低，没有sample，我们下载了一个0.2.5，提取了里面的shell.cc 删改些代码，用于0.1.5版本  
带sample的地址：[https://github.com/8427003/v8-0.1.5-mirror](https://github.com/8427003/v8-0.1.5-mirror)  
工具：clion , 主要靠全文搜索关键字从入口开始分析函数调用路径  
环境：用了虚拟机i386 centos 6，由于低版本只支持arm + i386， mac 上docker i386编译会出问题（放弃）  
编译工具：scons 用的v1.0.0 源码编译安装，高版本的scons 是无法编译v8-0.1.5的  
入口文件：shell.cc （带sample的地址里才会有shell.cc 文件）

关键字：

```
v8::Handle<v8::Script> script = v8::Script::Compile(source); 
Local<Script> Script::Compile(v8::Handle<String> source,
Handle<JSFunction> Compiler::Compile(Handle<String> source,
    MakeFunction(true, false, script, extension, pre_data);
    static Handle<JSFunction> MakeFunction(bool is_global,
        FunctionLiteral* lit = MakeAST(is_global, script, extension, pre_data);

            //这里很重要，会为每个函数分配一个parser，parser.cc 里会有一个top_scope成员变量
            // 这个top_scope会存放函数里的约束变量
            FunctionLiteral* MakeAST(bool compile_in_global_context, 

            FunctionLiteral* result = parser.ParseProgram(source,             FunctionLiteral* Parser::ParseProgram(Handle<String> source,
                scanner_.Init(source, stream, 0);
                void Scanner::Init(Handle<String> source, unibrow::CharacterStream* stream,
            ParseSourceElements(&body, Token::EOS, &ok);
            void* Parser::ParseSourceElements(ZoneListWrapper<Statement>* processor,
            Statement* stat = ParseStatement(NULL, CHECK_OK);
            Statement* Parser::ParseStatement(ZoneStringList* labels, bool* ok) {

                // 开始扫描 变量申明                 Block* Parser::ParseVariableStatement(bool* ok) {
                                  // var a = 1; 赋值表达式分析
                    Block* Parser::ParseVariableDeclarations(bool accept_IN,

                    // left  as proxy, 变量name与proxy绑定
                    VariableProxy* AstBuildingParser::Declare(Handle<String> name,
                        Variable* Scope::Declare(Handle<String> name, Variable::Mode mode) {

                    // right value, 简单的var a = 1; 在分析=号右边值时比较复杂，是一个漫长过程
                    value = ParseAssignmentExpression(accept_IN, CHECK_OK);
                    Expression* Parser::ParseAssignmentExpression(bool accept_IN, bool* ok) {
                    Expression* Parser::ParseConditionalExpression(bool accept_IN, bool* ok) {
                    Expression* expression = ParseBinaryExpression(4, accept_IN, CHECK_OK);
                    Expression* Parser::ParseBinaryExpression(int prec, bool accept_IN, bool* ok) {
                    Expression* x = ParseUnaryExpression(CHECK_OK);
                    Expression* Parser::ParseUnaryExpression(bool* ok) {
                    return ParsePostfixExpression(ok);
                    Expression* Parser::ParsePostfixExpression(bool* ok) {
                    Expression* result = ParseLeftHandSideExpression(CHECK_OK);
                    Expression* Parser::ParseLeftHandSideExpression(bool* ok) {
                    result = ParseMemberExpression(CHECK_OK);
                    Expression* Parser::ParseMemberExpression(bool* ok) {
                    return ParseMemberWithNewPrefixesExpression(&new_positions, ok);
                    Expression* Parser::ParseMemberWithNewPrefixesExpression(
                    result = ParsePrimaryExpression(CHECK_OK);
                    Expression* Parser::ParsePrimaryExpression(bool* ok) {
                        case Token::NUMBER: {
                        result = NewNumberLiteral(value);
                        Literal* Parser::NewNumberLiteral(double number) {

                    // left + right
                    // block ->  ExpressionStatement -> Assignment ->    target: VariableProxy + value: express
                    Assignment* assignment = NEW(Assignment(op, last_var, value, position));

                // 函数申明
                return ParseFunctionDeclaration(ok);
                Statement* Parser::ParseFunctionDeclaration(bool* ok) {




        Handle<Code> code = MakeCode(lit, script, is_eval);
            static Handle<Code> MakeCode(FunctionLiteral* literal,
            Handle<Code> result = CodeGenerator::MakeCode(literal, script, is_eval);
            Handle<Code> CodeGenerator::MakeCode(FunctionLiteral* fun,
            Handle<Code> Ia32CodeGenerator::MakeCode(FunctionLiteral* flit,
                cgen.GenCode(flit);
                void Ia32CodeGenerator::GenCode(FunctionLiteral* fun) {
                    VisitStatements(body);
                    void Visitor::VisitStatements(ZoneList<Statement*>* statements) {
                    void Visit(Node* node) { node->Accept(this); }
                    #define DECL_ACCEPT(type)   

                                     // var a = 1; 赋值表达式分析
                    void Ia32CodeGenerator::VisitBlock(Block* node) {
                    void Visitor::VisitStatements(ZoneList<Statement*>* statements) {
                    void Ia32CodeGenerator::VisitExpressionStatement(ExpressionStatement* node) {
                    void Ia32CodeGenerator::Load(Expression* x, CodeGenState::AccessType access) {
                    void Ia32CodeGenerator::LoadCondition(Expression* x,
                        Visit(x);
                        void Ia32CodeGenerator::VisitCallRuntime(CallRuntime* node) {
                            Load(args->at(i));
                            void Ia32CodeGenerator::VisitLiteral(Literal* node) {    
                            void Ia32CodeGenerator::VisitLiteral(Literal* node) {
                            __ CallRuntime(function, args->length());
                            void MacroAssembler::CallRuntime(Runtime::Function* f, int num_arguments) {
                                void MacroAssembler::CallStub(CodeStub* stub) {
                                Handle<Code> CodeStub::GetCode() {
                                virtual void Generate(MacroAssembler* masm) = 0;
                                void RuntimeStub::Generate(MacroAssembler* masm) {


                    // void Ia32CodeGenerator::VisitVariableProxy(VariableProxy* proxy_node) {
                    void Ia32CodeGenerator::VisitAssignment(Assignment* node) {
                    void SetValue(Reference* ref) { AccessReference(ref, CodeGenState::STORE); }
                    void Ia32CodeGenerator::AccessReference(Reference* ref,
```



