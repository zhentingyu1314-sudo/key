const { 
    Client, GatewayIntentBits, EmbedBuilder, ActionRowBuilder, ButtonBuilder, 
    ButtonStyle, ModalBuilder, TextInputBuilder, TextInputStyle, InteractionType, 
    REST, Routes 
} = require('discord.js');
const mongoose = require('mongoose');
const express = require('express');

// --- 核心配置 ---
const CONFIG = {
    MONGO_URI: "mongodb+srv://iamnotvoidgamer_db_user:rCqPPgfHLLaEZjFU@cluster0.nxr2wxk.mongodb.net/?appName=Cluster0",
    DISCORD_TOKEN: "MTQ5NTEwNTg3Mzg3MjE2MjkyNg.GMLut1.Wqm1r1-EPEFsf793qPCjglHNbsdxZBC9TG5IcY", 
    CLIENT_ID: "1495105873872162926", 
    GUILD_ID: "1495093952443846666",
    ROLE_ID: "1495103236057596015",
    PANEL_CHANNEL: "1495103030004154428",
    PORT: process.env.PORT || 3000
};

// --- 資料庫架構 ---
const KeyModel = mongoose.model('Key', new mongoose.Schema({
    key: { type: String, required: true, unique: true },
    hwid: { type: String, default: null },
    createdAt: { type: Date, default: Date.now }
}));

// --- Bot 初始化 ---
const client = new Client({ 
    intents: [
        GatewayIntentBits.Guilds, 
        GatewayIntentBits.GuildMembers, 
        GatewayIntentBits.GuildMessages 
    ] 
});

const rest = new REST({ version: '10' }).setToken(CONFIG.DISCORD_TOKEN);

// --- 啟動與指令註冊 ---
client.once('ready', async () => {
    console.log(`✅ Bot 已上線: ${client.user.tag}`);
    await mongoose.connect(CONFIG.MONGO_URI);
    
    try {
        const commands = [
            { name: 'gen', description: '生成 Key' },
            { name: 'force_reset', description: '重置 HWID', options: [{ name: 'key', type: 3, required: true, description: 'Key' }] },
            { name: 'force_delete', description: '刪除 Key', options: [{ name: 'key', type: 3, required: true, description: 'Key' }] }
        ];
        await rest.put(Routes.applicationGuildCommands(CONFIG.CLIENT_ID, CONFIG.GUILD_ID), { body: commands });
    } catch (err) { console.error(err); }

    const channel = await client.channels.fetch(CONFIG.PANEL_CHANNEL);
    if (channel) {
        const embed = new EmbedBuilder()
            .setTitle("🛡️ MOD8 授權系統")
            .setDescription("🔹 **Redeem**: 驗證 Key\n🔹 **Get Script**: 獲取腳本 (需身分組)\n🔹 **Reset HWID**: 重置綁定 (需身分組)")
            .setColor(0x00FF00);
        const row = new ActionRowBuilder().addComponents(
            new ButtonBuilder().setCustomId('btn_redeem').setLabel('Redeem Key').setStyle(ButtonStyle.Primary),
            new ButtonBuilder().setCustomId('btn_getscript').setLabel('Get Script').setStyle(ButtonStyle.Success),
            new ButtonBuilder().setCustomId('btn_reset').setLabel('Reset HWID').setStyle(ButtonStyle.Danger)
        );
        await channel.send({ embeds: [embed], components: [row] });
    }
});

// --- 互動邏輯 ---
client.on('interactionCreate', async (i) => {
    const hasRole = i.member.roles.cache.has(CONFIG.ROLE_ID);

    if (i.isChatInputCommand()) {
        if (!hasRole) return i.reply({ content: "❌ 權限不足", ephemeral: true });
        if (i.commandName === 'gen') {
            const newKey = "MOD8-" + Math.random().toString(36).substring(2, 12).toUpperCase();
            await KeyModel.create({ key: newKey });
            return i.reply({ content: `✅ 生成成功: \`${newKey}\``, ephemeral: true });
        }
        const key = i.options.getString('key');
        if (i.commandName === 'force_reset') {
            await KeyModel.updateOne({ key }, { $set: { hwid: null } });
            return i.reply({ content: `🔄 已重置 \`${key}\``, ephemeral: true });
        }
        if (i.commandName === 'force_delete') {
            await KeyModel.deleteOne({ key });
            return i.reply({ content: `🗑️ 已刪除 \`${key}\``, ephemeral: true });
        }
    }

    if (i.isButton()) {
        if (i.customId === 'btn_getscript') {
            if (!hasRole) return i.reply({ content: "❌ 無權限", ephemeral: true });
            
            const scriptCode = `-- [[ MOD8 LOADER ]]\n_G.script_key = "在此處輸入你的KEY"\nloadstring(game:HttpGet("https://你的Koyeb網址.koyeb.app/verify"))()`;
            
            return i.reply({ 
                content: "📜 **這是你的加載腳本：**\n```lua\n" + scriptCode + "\n```", 
                ephemeral: true 
            });
        }
        
        if (i.customId === 'btn_redeem' || i.customId === 'btn_reset') {
            if (i.customId === 'btn_reset' && !hasRole) return i.reply({ content: "❌ 無權限", ephemeral: true });
            
            const modal = new ModalBuilder()
                .setCustomId(i.customId === 'btn_redeem' ? 'm_redeem' : 'm_reset')
                .setTitle('輸入 Key');
            
            const input = new TextInputBuilder()
                .setCustomId('f_key')
                .setLabel("Key")
                .setStyle(TextInputStyle.Short)
                .setPlaceholder("MOD8-XXXX-XXXX")
                .setRequired(true);
            
            modal.addComponents(new ActionRowBuilder().addComponents(input));
            await i.showModal(modal);
        }
    }

    if (i.type === InteractionType.ModalSubmit) {
        const inputKey = i.fields.getTextInputValue('f_key');
        const data = await KeyModel.findOne({ key: inputKey });
        
        if (!data) return i.reply({ content: "❌ 無效 Key，請聯繫管理員", ephemeral: true });
        
        if (i.customId === 'm_reset') {
            await KeyModel.updateOne({ key: inputKey }, { $set: { hwid: null } });
            return i.reply({ content: "✅ HWID 已成功重置，您現在可以在新設備登入。", ephemeral: true });
        }
        
        return i.reply({ content: "✅ Key 有效！請將此 Key 填入腳本中使用。", ephemeral: true });
    }
});

// --- API ---
const app = express();
app.get('/verify', async (req, res) => {
    const { key, hwid } = req.query;
    if (!key || !hwid) return res.send("invalid_params");

    const data = await KeyModel.findOne({ key });
    if (!data) return res.send("invalid");
    
    if (!data.hwid) {
        data.hwid = hwid;
        await data.save();
        return res.send("success");
    }
    
    return res.send(data.hwid === hwid ? "success" : "hwid_mismatch");
});

app.listen(CONFIG.PORT, () => console.log(`🚀 API 運行中，端口: ${CONFIG.PORT}`));
client.login(CONFIG.DISCORD_TOKEN);
